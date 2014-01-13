#include "saatgutwidget.h"
#include "ui_saatgutwidget.h"
#include "insertsaatgutdialog.h"
#include <QtSql/QSqlDatabase>
#include <QDebug>
#include <QSqlError>
#include <QSqlQuery>
#include <QSqlQueryModel>
#include <QMessageBox>
#include "errordialog.h"

SaatgutWidget::SaatgutWidget(QWidget *parent) :
	QWidget(parent),
	ui(new Ui::SaatgutWidget)
{
	ui->setupUi(this);
	saatgut = new QSqlTableModel(ui->tableSaagut);
	saatgut->setTable("saatgut");
	saatgut->setEditStrategy(QSqlTableModel::OnFieldChange);
	bestand = new QSqlQueryModel(ui->tableSaatgutbestand_2);

	if(saatgut->select() != true) {
		ErrorDialog() << saatgut->lastError();
	}

	ui->tableSaagut->setModel(saatgut);
	ui->tableSaagut->setSelectionBehavior(QAbstractItemView::SelectRows);
	ui->tableSaagut->setSelectionMode(QAbstractItemView::SingleSelection);

	// PK verstecken
	ui->tableSaagut->hideColumn(0);
}

SaatgutWidget::~SaatgutWidget()
{
	delete bestand;
	delete saatgut;
	delete ui;
}

void SaatgutWidget::on_tableSaagut_clicked(const QModelIndex &index)
{
	bool ok = false;
	currentPk = (saatgut->index(index.row(), 0)).data().toInt(&ok);

	if (currentPk <= 0 || !ok) {
		ErrorDialog() << saatgut->lastError();
	} else {
		QSqlQuery q;
		if (!q.exec(QString("SELECT * FROM usp_SaatgutLagerBestand(%1)").arg(currentPk))) {
			ErrorDialog() << q.lastError();
		}
		bestand->setQuery(q);
		ui->tableSaatgutbestand_2->setModel(bestand);
		ui->tableSaatgutbestand_2->hideColumn(0);
	}
}

void SaatgutWidget::on_SaatgutNeu_clicked()
{
	InsertSaatgutDialog d;
	d.setModal(true);
	d.exec();
	saatgut->select();

}

void SaatgutWidget::on_SaatgutTot_clicked()
{
	QSqlQuery q;
	q.prepare("SELECT usp_DeleteSaatgut(?, 'f');");
	q.bindValue(0,currentPk);
	if (!q.exec()) {
		QMessageBox m;
		m.setText("Wenn sie fortfahren werden alle Einträge gelöscht die mit diesem Saatgut in verbindung stehen.");
		m.setStandardButtons(QMessageBox::Yes | QMessageBox::No);
		m.setIcon(QMessageBox::Warning);
		m.setDefaultButton(QMessageBox::No);
		int ret = m.exec();
		switch (ret) {
		case QMessageBox::Yes:
			q.clear();
			q.prepare("SELECT usp_DeleteSaatgut(?, 't');");
			q.bindValue(0,currentPk);
			if (!q.exec()) {
				ErrorDialog() << q.lastError(); //need more indent
			}
			break;
		default:
			break;
		}
	}
	saatgut->select();
}
