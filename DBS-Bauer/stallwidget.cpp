#include "stallwidget.h"
#include "ui_stallwidget.h"
#include "insertstalldialog.h"
#include <QtSql/QSqlDatabase>
#include <QDebug>
#include <QSqlError>
#include <QSqlQuery>
#include <QMessageBox>
#include "errordialog.h"

StallWidget::StallWidget(QWidget *parent) :
	QWidget(parent),
	ui(new Ui::StallWidget)
{
	ui->setupUi(this);
	arbeiten = new QSqlQueryModel(ui->tableStallarbeiten);
	tiere = new QSqlQueryModel(ui->tableStallTiere);
	staelle = new QSqlTableModel(ui->tableStall);
	staelle->setTable("stall");
	staelle->setEditStrategy(QSqlTableModel::OnFieldChange);

	if (!staelle->select()) {
		qDebug() << staelle->lastError();
	}
	ui->tableStall->setModel(staelle);
	ui->tableStall->setSelectionBehavior(QAbstractItemView::SelectRows);
	ui->tableStall->setSelectionMode(QAbstractItemView::SingleSelection);

	// pk_staelle verstecken
	ui->tableStall->hideColumn(0);
}

StallWidget::~StallWidget()
{
	delete staelle;
	delete tiere;
	delete arbeiten;
	delete ui;
}

void StallWidget::on_tableStall_clicked(const QModelIndex &index)
{
	bool ok = false;
	currentPk = (staelle->index(index.row(), 0)).data().toInt(&ok);

	if (currentPk <= 0 || !ok) {
		qDebug() << staelle->lastError();
	} else {
		SetupSubTables(index);
	}
}

void StallWidget::SetupSubTables(const QModelIndex &index)
{
	SetupTiere(index);
	SetupArbeiten(index);
}

void StallWidget::SetupTiere(const QModelIndex &index)
{
	QSqlQuery q;
	if (!q.exec(QString("SELECT * FROM usp_TiereImStall(%1)").arg(currentPk))) {
		qDebug() << q.lastError();
	}
	tiere->setQuery(q);
	ui->tableStallTiere->setModel(tiere);
	ui->tableStallTiere->hideColumn(0);
}

void StallWidget::SetupArbeiten(const QModelIndex &index)
{
	QSqlQuery q;
	if (!q.exec(QString("SELECT * FROM usp_Stallarbeiten(%1)").arg(currentPk))) {
		qDebug() << q.lastError();
	}
	arbeiten->setQuery(q);
	ui->tableStallarbeiten->setModel(arbeiten);
	ui->tableStallarbeiten->hideColumn(0);
}

void StallWidget::on_stalleinfuegen_clicked()
{
	InsertStallDialog d;
	d.setModal(true);
	d.exec();
	staelle->select();
}

void StallWidget::on_stalltot_clicked()
{
	QSqlQuery q;
	if (!q.exec(QString("SELECT usp_DeleteStall(%1, 'f') ;").arg(QString::number(currentPk)))) {


		QMessageBox m;
		m.setText("Wenn sie fortfahren werden alle Tiere und Stallarbeiten gelöscht die mit diesem Stall in verbindung stehen.");
		m.setStandardButtons(QMessageBox::Yes | QMessageBox::No);
		m.setIcon(QMessageBox::Warning);
		m.setDefaultButton(QMessageBox::No);
		int ret = m.exec();
		switch (ret) {
		case QMessageBox::Yes:

			if (!q.exec(QString("SELECT usp_DeleteStall(%1, 't') ;").arg(QString::number(currentPk)))) {
				qDebug() << q.lastError(); //need more indent
			}
			break;
		default:
			break;
		}
	}
	staelle->select();

}
