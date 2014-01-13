#include "duengerwidget.h"
#include "ui_duengerwidget.h"
#include "insertduengerdialog.h"
#include <QtSql/QSqlDatabase>
#include <QDebug>
#include <QSqlError>
#include <QSqlQuery>
#include <QSqlQueryModel>
#include <QMessageBox>
#include "errordialog.h"

DuengerWidget::DuengerWidget(QWidget *parent) :
	QWidget(parent),
	ui(new Ui::DuengerWidget)
{
	ui->setupUi(this);
	bestand = new QSqlQueryModel(ui->tableDungerbestand_2);
	dunger = new QSqlTableModel(ui->tableDunger);
	dunger->setTable("duenger");

	if(!dunger->select()) {
		ErrorDialog() << dunger->lastError();
	}

	ui->tableDunger->setModel(dunger);
	ui->tableDunger->setSelectionBehavior(QAbstractItemView::SelectRows);
	ui->tableDunger->setSelectionMode(QAbstractItemView::SingleSelection);
	ui->tableDunger->setEditTriggers(QAbstractItemView::NoEditTriggers);

	// PK verstecken
	ui->tableDunger->hideColumn(0);
}

DuengerWidget::~DuengerWidget()
{
	delete bestand;
	delete dunger;
	delete ui;
}

void DuengerWidget::on_tableDunger_clicked(const QModelIndex &index)
{
	bool ok = false;
	currentPk = (dunger->index(index.row(), 0)).data().toInt(&ok);

	if (currentPk <= 0 || !ok) {
		ErrorDialog() << dunger->lastError();
	} else {
		QSqlQuery q;
		if (!q.exec(QString("SELECT * FROM usp_DuengerLagerBestand(%1)").arg(currentPk))) {
			ErrorDialog() << q.lastError();
		}
		bestand->setQuery(q);
		ui->tableDungerbestand_2->setModel(bestand);
		ui->tableDungerbestand_2->hideColumn(0);
	}
}

void DuengerWidget::on_DuengerNeu_clicked()
{
	InsertDuengerDialog d;
	d.setModal(true);
	d.exec();
	dunger->select();
}

void DuengerWidget::on_DuengerTot_clicked()
{
	QSqlQuery q;
	q.prepare("SELECT usp_DeleteDuenger(?, 'f');");
	q.bindValue(0,currentPk);
	if (!q.exec()) {
		QMessageBox m;
		m.setText("Wenn sie fortfahren werden alle Einträge gelöscht die mit diesem Dünger in verbindung stehen.");
		m.setStandardButtons(QMessageBox::Yes | QMessageBox::No);
		m.setIcon(QMessageBox::Warning);
		m.setDefaultButton(QMessageBox::No);
		int ret = m.exec();
		switch (ret) {
		case QMessageBox::Yes:
			q.clear();
			q.prepare("SELECT usp_DeleteDuenger(?, 't');");
			q.bindValue(0,currentPk);
			if (!q.exec()) {
				ErrorDialog() << q.lastError(); //need more indent
			}
			break;
		default:
			break;
		}
	}
	dunger->select();
}
