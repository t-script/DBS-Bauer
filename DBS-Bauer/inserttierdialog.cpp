#include "inserttierdialog.h"
#include "ui_inserttierdialog.h"
#include <QtSql/QSqlDatabase>
#include <QDebug>
#include <QSqlError>
#include <QSqlQuery>

InsertTierDialog::InsertTierDialog(QWidget *parent) :
	QDialog(parent),
	ui(new Ui::InsertTierDialog)
{
	ui->setupUi(this);
	ui->geburtsDatum->setDate(QDate::currentDate());
	ui->anschaffungsDatum->setDate(QDate::currentDate());
	SetupFutter();
	SetupTierart();
	SetupStall();
}

InsertTierDialog::~InsertTierDialog()
{
	delete ui;
}

void InsertTierDialog::on_buttonBox_accepted()
{
	QSqlQuery q;

	QString insertQuery =
			QString("SELECT usp_TierHinzufuegen(%1,'%2','%3','%4',%5,'%6',%7,%8)")
			.arg(
				QString::number(ui->stall->currentIndex() + 1),
				ui->Name->text(),
				ui->geburtsDatum->date().toString("yyyy-MM-dd"),
				ui->anschaffungsDatum->date().toString("yyyy-MM-dd"),
				QString::number(ui->gewicht->value()),
				ui->tierart->currentText(),
				QString::number(ui->futter->currentIndex()),
				QString::number(ui->futterMenge->value())
			);
	if(!q.exec(insertQuery)) {
		qDebug() << q.lastError();
	}
}

void InsertTierDialog::SetupTierart()
{
	QSqlQuery q;

	ui->tierart->clear();

	if(!q.exec("SELECT * FROM usp_GetAttribut('Tierart')")) {
		qDebug() << q.lastError();
	}

	while(q.next()) {
		ui->tierart->addItem(q.value(0).toString());
	}
	ui->tierart->setCurrentIndex(0);
	ui->tierart->update();
	ui->tierart->show();
}

void InsertTierDialog::SetupFutter()
{
	QSqlQuery q;

	ui->futter->clear();

	if(!q.exec("SELECT * FROM \"v_FutterName\"")) {
		qDebug() << q.lastError();
	}

	while(q.next()) {
		ui->futter->addItem(q.value(0).toString());
	}
	ui->futter->setCurrentIndex(0);
	ui->futter->update();
	ui->futter->show();
}

void InsertTierDialog::SetupStall()
{
	QSqlQuery q;

	ui->stall->clear();

	if(!q.exec("SELECT * FROM \"v_Stallart\"")) {
		qDebug() << q.lastError();
	}

	while(q.next()) {
		ui->stall->addItem(q.value(0).toString());
	}
	ui->stall->setCurrentIndex(0);
	ui->stall->update();
	ui->stall->show();
}
