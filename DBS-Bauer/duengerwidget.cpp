#include "duengerwidget.h"
#include "ui_duengerwidget.h"
#include <QtSql/QSqlDatabase>
#include <QDebug>
#include <QSqlError>
#include <QSqlQuery>
#include <QSqlQueryModel>

DuengerWidget::DuengerWidget(QWidget *parent) :
	QWidget(parent),
	ui(new Ui::DuengerWidget)
{
	ui->setupUi(this);
	bestand = new QSqlQueryModel(ui->tableDungerbestand_2);
	dunger = new QSqlTableModel(ui->tableDunger);
	dunger->setTable("duenger");

	if(!dunger->select()) {
		qDebug() << dunger->lastError();
	}

	ui->tableDunger->setModel(dunger);
	ui->tableDunger->setSelectionBehavior(QAbstractItemView::SelectRows);
	ui->tableDunger->setSelectionMode(QAbstractItemView::SingleSelection);
	ui->tableDunger->setEditTriggers(QAbstractItemView::NoEditTriggers);

	// PK verstecken
	ui->tableDunger->hideColumn(0);
}

DuengerWidget::~DuengerWidget()
{
	delete bestand;
	delete dunger;
	delete ui;
}

void DuengerWidget::on_tableDunger_clicked(const QModelIndex &index)
{
	bool ok = false;
	int currentPk = (dunger->index(index.row(), 0)).data().toInt(&ok);

	if (currentPk <= 0 || !ok) {
		qDebug() << dunger->lastError();
	} else {
		QSqlQuery q;
		if (!q.exec(QString("SELECT * FROM usp_DuengerLagerBestand(%1)").arg(currentPk))) {
			qDebug() << q.lastError();
		}
		bestand->setQuery(q);
		ui->tableDungerbestand_2->setModel(bestand);
		ui->tableDungerbestand_2->hideColumn(0);
	}
}
