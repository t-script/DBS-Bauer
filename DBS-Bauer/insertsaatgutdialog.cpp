#include "insertsaatgutdialog.h"
#include "ui_insertsaatgutdialog.h"
#include <QtSql/QSqlDatabase>
#include <QDebug>
#include <QSqlError>
#include <QSqlQuery>
#include "errordialog.h"

InsertSaatgutDialog::InsertSaatgutDialog(QWidget *parent) :
	QDialog(parent),
	ui(new Ui::InsertSaatgutDialog)
{
	ui->setupUi(this);
	SetupLager();
}

InsertSaatgutDialog::~InsertSaatgutDialog()
{
	delete ui;
}

void InsertSaatgutDialog::on_buttonBox_2_accepted()
{
	QSqlQuery q;
	q.prepare("SELECT PK_Lager FROM LAGER WHERE Lagerart = ?");
	q.bindValue(0,ui->Lager->currentText());
	q.exec();
	q.first();
	int pk = q.value(0).toInt();
	q.clear();

	q.prepare("SELECT usp_SaatgutEinfuegen(?,?,?,?)");
	q.bindValue(0,ui->Name->text());
	q.bindValue(1,ui->Preis->value());
	q.bindValue(2,pk);
	q.bindValue(3,ui->Bestand->value());
	if(!q.exec()){
		ErrorDialog() << q.lastError();
	}

}

void InsertSaatgutDialog::SetupLager()
{
	QSqlQuery q;

	ui->Lager->clear();

	if(!q.exec("SELECT * FROM \"v_Lagername\"")) {
		ErrorDialog() << q.lastError();
	}

	while(q.next()) {
		ui->Lager->addItem(q.value(0).toString());
	}
	ui->Lager->setCurrentIndex(0);
	ui->Lager->update();
	ui->Lager->show();
}
