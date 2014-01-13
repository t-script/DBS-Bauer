#include "insertangestellterdialog.h"
#include "ui_insertangestellterdialog.h"
#include <QtSql/QSqlDatabase>
#include <QDebug>
#include <QSqlError>
#include <QSqlQuery>
#include "errordialog.h"

InsertAngestellterDialog::InsertAngestellterDialog(QWidget *parent) :
	QDialog(parent),
	ui(new Ui::InsertAngestellterDialog)
{
	ui->setupUi(this);
	ui->Geschlecht->addItem("Männlich");
	ui->Geschlecht->addItem("Weiblich");
}

InsertAngestellterDialog::~InsertAngestellterDialog()
{
	delete ui;
}

void InsertAngestellterDialog::on_buttonBox_accepted()
{
	QString geschl;
	if(ui->Geschlecht->currentIndex() == 0) {
		geschl = "maennlich";
	} else {
		geschl = "weiblich";
	}
	QSqlQuery q;
	q.prepare("SELECT usp_AngestellterEinfuegen(?,?,?,?,?,?)");
	q.bindValue(0, ui->Vorname->text());
	q.bindValue(1, ui->Nachname->text());
	q.bindValue(2, ui->SVN->text());
	q.bindValue(3, ui->Gehalt->value());
	q.bindValue(4, ui->Bankdaten->text());
	q.bindValue(5, geschl);
	if(!q.exec()) {
		ErrorDialog() << q.lastError();
	}
}
