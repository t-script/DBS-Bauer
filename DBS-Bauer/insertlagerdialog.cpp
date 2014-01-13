#include "insertlagerdialog.h"
#include "ui_insertlagerdialog.h"
#include <QtSql/QSqlDatabase>
#include <QDebug>
#include <QSqlError>
#include <QSqlQuery>
#include "errordialog.h"

InsertLagerDialog::InsertLagerDialog(QWidget *parent) :
	QDialog(parent),
	ui(new Ui::InsertLagerDialog)
{
	ui->setupUi(this);
}

InsertLagerDialog::~InsertLagerDialog()
{
	delete ui;
}

void InsertLagerDialog::on_buttonBox_accepted()
{
	QSqlQuery q;
	q.prepare("SELECT usp_LagerEinfuegen(?,?)");
	q.bindValue(0,ui->Lagerart->text());
	q.bindValue(1,ui->Kapazitaet->value());
	if(!q.exec()) {
		ErrorDialog() << q.lastError();
	}
}
