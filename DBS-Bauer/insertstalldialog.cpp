#include "insertstalldialog.h"
#include "ui_insertstalldialog.h"
#include <QtSql/QSqlDatabase>
#include <QDebug>
#include <QSqlError>
#include <QSqlQuery>


InsertStallDialog::InsertStallDialog(QWidget *parent) :
	QDialog(parent),
	ui(new Ui::InsertStallDialog)
{
	ui->setupUi(this);
}

InsertStallDialog::~InsertStallDialog()
{
	delete ui;
}

void InsertStallDialog::on_buttonBox_accepted()
{
	QSqlQuery q;

	QString insertQuery =
			QString("SELECT usp_StallEinfuegen('%1','%2','%3') ")
			.arg(
				ui->stallart->text(),
				QString::number(ui->kapazitaet->value()),
				ui->standort->text()
			);
	if(!q.exec(insertQuery)) {
		qDebug() << q.lastError();
	}
}
