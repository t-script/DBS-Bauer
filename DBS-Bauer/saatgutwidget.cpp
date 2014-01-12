#include "saatgutwidget.h"
#include "ui_saatgutwidget.h"
#include <QtSql/QSqlDatabase>
#include <QDebug>
#include <QSqlError>
#include <QSqlQuery>
#include <QSqlQueryModel>

SaatgutWidget::SaatgutWidget(QWidget *parent) :
	QWidget(parent),
	ui(new Ui::SaatgutWidget)
{
	ui->setupUi(this);
	saatgut = new QSqlTableModel(ui->tableSaagut);
	saatgut->setTable("saatgut");
	bestand = new QSqlQueryModel(ui->tableSaatgutbestand_2);

	if(saatgut->select() != true) {
		qDebug() << saatgut->lastError();
	}

	ui->tableSaagut->setModel(saatgut);
	ui->tableSaagut->setSelectionBehavior(QAbstractItemView::SelectRows);
	ui->tableSaagut->setSelectionMode(QAbstractItemView::SingleSelection);
	ui->tableSaagut->setEditTriggers(QAbstractItemView::NoEditTriggers);

	// PK verstecken
	ui->tableSaagut->hideColumn(0);
}

SaatgutWidget::~SaatgutWidget()
{
	delete bestand;
	delete saatgut;
	delete ui;
}

void SaatgutWidget::on_tableSaagut_clicked(const QModelIndex &index)
{
	bool ok = false;
	int currentPk = (saatgut->index(index.row(), 0)).data().toInt(&ok);

	if (currentPk <= 0 || !ok) {
		qDebug() << saatgut->lastError();
	} else {
		QSqlQuery q;
		if (!q.exec(QString("SELECT * FROM usp_SaatgutLagerBestand(%1)").arg(currentPk))) {
			qDebug() << q.lastError();
		}
		bestand->setQuery(q);
		ui->tableSaatgutbestand_2->setModel(bestand);
		ui->tableSaatgutbestand_2->hideColumn(0);
	}
}
