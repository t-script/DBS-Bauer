#include "insertduengerdialog.h"
#include "ui_insertduengerdialog.h"
#include <QtSql/QSqlDatabase>
#include <QDebug>
#include <QSqlError>
#include <QSqlQuery>

InsertDuengerDialog::InsertDuengerDialog(QWidget *parent) :
	QDialog(parent),
	ui(new Ui::InsertDuengerDialog)
{
	ui->setupUi(this);
	SetupLager();
}

InsertDuengerDialog::~InsertDuengerDialog()
{
	delete ui;
}

void InsertDuengerDialog::on_buttonBox_accepted()
{
	QSqlQuery q;
	q.prepare("SELECT PK_Lager FROM LAGER WHERE Lagerart = ?");
	q.bindValue(0,ui->Lager->currentText());
	q.exec();
	q.first();
	int pk = q.value(0).toInt();
	q.clear();
	q.prepare("SELECT usp_DuengerEinfuegen(?,?,?,?)");
	q.bindValue(0,ui->Name->text());
	q.bindValue(1,ui->Preis->value());
	q.bindValue(2,pk);
	q.bindValue(3,ui->Bestand->value());
	if(!q.exec()){
		qDebug() << q.lastError();
	}

}

void InsertDuengerDialog::SetupLager()
{
	QSqlQuery q;

	ui->Lager->clear();

	if(!q.exec("SELECT * FROM \"v_Lagername\"")) {
		qDebug() << q.lastError();
	}

	while(q.next()) {
		ui->Lager->addItem(q.value(0).toString());
	}
	ui->Lager->setCurrentIndex(0);
	ui->Lager->update();
	ui->Lager->show();
}
