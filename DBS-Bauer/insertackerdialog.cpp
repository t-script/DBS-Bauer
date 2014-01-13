#include "insertackerdialog.h"
#include "ui_insertackerdialog.h"
#include <QtSql/QSqlDatabase>
#include <QDebug>
#include <QSqlError>
#include <QSqlQuery>

InsertAckerDialog::InsertAckerDialog(QWidget *parent) :
	QDialog(parent),
	ui(new Ui::InsertAckerDialog)
{
	ui->setupUi(this);
}

InsertAckerDialog::~InsertAckerDialog()
{
	delete ui;
}

void InsertAckerDialog::on_buttonBox_accepted()
{
	QSqlQuery q;
	q.prepare("SELECT usp_AckerEinfuegen(?,?)");
	q.bindValue(0,ui->Standort->text());
	q.bindValue(1,ui->Groesse->value());
	if(!q.exec()) {
		qDebug() << q.lastError();
	}

}
