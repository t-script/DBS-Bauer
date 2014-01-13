#include "insertmaschinedialog.h"
#include "ui_insertmaschinedialog.h"
#include <QtSql/QSqlDatabase>
#include <QDebug>
#include <QSqlError>
#include <QSqlQuery>
#include "errordialog.h"

InsertMaschineDialog::InsertMaschineDialog(QWidget *parent) :
	QDialog(parent),
	ui(new Ui::InsertMaschineDialog)
{
	ui->setupUi(this);
	ui->Abschreibungsdatum->setDate(QDate::currentDate());
	ui->Anschaffungsdatum->setDate(QDate::currentDate());
	SetupLager();
}

InsertMaschineDialog::~InsertMaschineDialog()
{
	delete ui;
}

void InsertMaschineDialog::on_buttonBox_accepted()
{
	QSqlQuery q;
	q.prepare("SELECT PK_Lager FROM LAGER WHERE Lagerart = ?");
	q.bindValue(0,ui->Lager->currentText());
	q.exec();
	q.first();
	int pk = q.value(0).toInt();
	q.clear();
	q.prepare("SELECT usp_MaschineEinfuegen (?,?,?,?,?,?)");
	q.bindValue(0, pk);
	q.bindValue(1,ui->Kosten->value());
	q.bindValue(2,ui->Typ->text());
	q.bindValue(3,ui->Name->text());
	q.bindValue(4,ui->Anschaffungsdatum->date().toString("yyyy-MM-dd"));
	q.bindValue(5,ui->Abschreibungsdatum->date().toString("yyyy-MM-dd"));
	if(!q.exec()){
		ErrorDialog() << q.lastError();
	}
}

void InsertMaschineDialog::SetupLager()
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
