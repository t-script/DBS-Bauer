#include "stallwidget.h"
#include "ui_stallwidget.h"
#include <QtSql/QSqlDatabase>
#include <QDebug>
#include <QSqlError>
#include <QSqlQuery>

StallWidget::StallWidget(QWidget *parent) :
	QWidget(parent),
	ui(new Ui::StallWidget)
{
	ui->setupUi(this);
	arbeiten = new QSqlQueryModel(ui->tableStallarbeiten);
	tiere = new QSqlQueryModel(ui->tableStallTiere);
	staelle = new QSqlTableModel(ui->tableStall);
	staelle->setTable("stall");

	if (!staelle->select()) {
		qDebug() << staelle->lastError();
	}
	ui->tableStall->setModel(staelle);
	ui->tableStall->setSelectionBehavior(QAbstractItemView::SelectRows);
	ui->tableStall->setSelectionMode(QAbstractItemView::SingleSelection);
	ui->tableStall->setEditTriggers(QAbstractItemView::NoEditTriggers);

	// pk_staelle verstecken
	ui->tableStall->hideColumn(0);
}

StallWidget::~StallWidget()
{
	delete staelle;
	delete tiere;
	delete arbeiten;
	delete ui;
}

void StallWidget::on_tableStall_clicked(const QModelIndex &index)
{
	bool ok = false;
	currentPk = (staelle->index(index.row(), 0)).data().toInt(&ok);

	if (currentPk <= 0 || !ok) {
		qDebug() << staelle->lastError();
	} else {
		SetupSubTables(index);
	}
}

void StallWidget::SetupSubTables(const QModelIndex &index)
{
	SetupTiere(index);
	SetupArbeiten(index);
}

void StallWidget::SetupTiere(const QModelIndex &index)
{
	QSqlQuery q;
	if (!q.exec(QString("SELECT * FROM usp_TiereImStall(%1)").arg(currentPk))) {
		qDebug() << q.lastError();
	}
	tiere->setQuery(q);
	ui->tableStallTiere->setModel(tiere);
	ui->tableStallTiere->hideColumn(0);
}

void StallWidget::SetupArbeiten(const QModelIndex &index)
{
	QSqlQuery q;
	if (!q.exec(QString("SELECT * FROM usp_Stallarbeiten(%1)").arg(currentPk))) {
		qDebug() << q.lastError();
	}
	arbeiten->setQuery(q);
	ui->tableStallarbeiten->setModel(arbeiten);
	ui->tableStallarbeiten->hideColumn(0);
}
