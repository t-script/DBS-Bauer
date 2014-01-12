#include "inserttierdialog.h"
#include "ui_inserttierdialog.h"
#include <QtSql/QSqlDatabase>
#include <QDebug>
#include <QSqlError>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QException>
#include <QSqlTableModel>

InsertTierDialog::InsertTierDialog(QWidget *parent) :
	QDialog(parent),
	ui(new Ui::InsertTierDialog)
{
	ui->setupUi(this);
	SetupFutter();
	SetupTierart();
}

InsertTierDialog::~InsertTierDialog()
{
	delete ui;
}

void InsertTierDialog::on_buttonBox_accepted()
{

}

void InsertTierDialog::SetupTierart()
{
	QSqlQuery q;

	ui->tierart->clear();

	if(!q.exec("SELECT Wert From ATTRIBUTE Where Name = 'Tierart'")) {
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

	if(!q.exec("SELECT Name From FUTTER")) {
		qDebug() << q.lastError();
	}

	while(q.next()) {
		ui->futter->addItem(q.value(0).toString());
	}
	ui->futter->setCurrentIndex(0);
	ui->futter->update();
	ui->futter->show();
}
