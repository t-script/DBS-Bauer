#include "tierwidget.h"
#include "ui_tierwidget.h"
#include <QtSql/QSqlDatabase>
#include <QDebug>
#include <QSqlError>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QException>

TierWidget::TierWidget(QWidget *parent) :
	QWidget(parent),
	ui(new Ui::TierWidget)
{
	ui->setupUi(this);
	tiere = new QSqlTableModel(ui->tableTier);
	tierarzt = new QSqlQueryModel(ui->tableArzt);
	attribute = new QSqlQueryModel(ui->tableAttribute);
	tiere->setTable("tier");
	if(tiere->select() != true) {
		qDebug() << tiere->lastError();
	}
	ui->tableTier->setModel(tiere);
	ui->tableArzt->setModel(tierarzt);

	/* pk und fk verstecken */
	ui->tableTier->hideColumn(0);
	ui->tableTier->hideColumn(1);

	ui->tableTier->setSelectionBehavior(QAbstractItemView::SelectRows);
	ui->tableTier->setSelectionMode(QAbstractItemView::SingleSelection);
	ui->tableTier->setEditTriggers(QAbstractItemView::NoEditTriggers);
}

TierWidget::~TierWidget()
{
	delete tiere;
	delete tierarzt;
	delete attribute;
	delete ui;
}

void TierWidget::on_tableTier_clicked(const QModelIndex &index)
{
	TierTableChanged(index);
}

void TierWidget::TierTableChanged(const QModelIndex &index)
{
	bool ok = false;
	_currentPk = index.column() == 0 ?
		index.data().toInt() :
		(tiere->index(index.row(), 0)).data().toInt(&ok);

	if (_currentPk <= 0 || !ok) {
		qDebug() << tiere->lastError();
	}
	SetupSubTables(index);
}

void TierWidget::on_tableAttribute_clicked(const QModelIndex &index)
{
}

void TierWidget::on_tableArzt_clicked(const QModelIndex &index)
{
}

void TierWidget::on_tableFutterTier_clicked(const QModelIndex &index)
{
}

void TierWidget::SetupSubTables(const QModelIndex &index)
{
	SetupStall(index);
	SetupAttribute(index);
	SetupTierarzt(index);
	SetupFutterTier(index);
}

void TierWidget::SetupStall(const QModelIndex &index)
{
	bool ok = false;
	int fkStall = index.column() == 1 ?
		index.data().toInt(&ok) :
		(tiere->index(index.row(), 1)).data().toInt(&ok);
	QSqlTableModel stall;
	stall.setTable("stall");
	ui->comboStall->clear();

	if (!stall.select() || !ok) {
		qDebug() << (ok ? "stall.select() failed" : "data().toInt() failed");
	}
	for (int i = 0; i < stall.rowCount(); i++) {
		ui->comboStall->addItem(stall.index(i, 1).data().toString());
	}
	ui->comboStall->setCurrentIndex(fkStall-1);
	ui->comboStall->update();
	ui->comboStall->show();
}

void TierWidget::SetupAttribute(const QModelIndex &index)
{
	QSqlQuery q;
	if (!q.exec(QString("SELECT * FROM usp_TierAttribute(%1);").arg(QString::number(_currentPk)))) {
		qDebug() << q.lastError();
	}
	attribute->setQuery(q);
	ui->tableAttribute->setModel(attribute);
	ui->tableAttribute->hideColumn(0);
}

void TierWidget::SetupTierarzt(const QModelIndex &index)
{
	QSqlQuery q;
	if (!q.exec(QString("SELECT * FROM usp_TierArztBesuche(%1)").arg(_currentPk))) {
		qDebug() << q.lastError();
	}
	tierarzt->setQuery(q);
	ui->tableArzt->setModel(tierarzt);
	ui->tableArzt->hideColumn(0);
}

void TierWidget::SetupFutterTier(const QModelIndex &index)
{
}

void TierWidget::on_comboStall_currentIndexChanged(int index)
{
	//int fkStall = index + 1;
	/*
	QSqlTableModel stall;
	stall.setTable("stall");

	if (!stall.select()) {
		qDebug() << stall.lastError();
	} else if (stall.query().exec("update tier set stall="+QString::number(fkStall)+" where pk_tier="+QString::number(_currentPk)+";")) {
		qDebug() << stall.lastError();
	}
	*/
	//qDebug() << "PK: " << _currentPk;
	//qDebug() << "FK: " << fkStall;
}

void TierWidget::on_comboStall_activated(int index)
{
	QSqlQuery q;
	if (!q.exec(QString("SELECT usp_UpdateTierStall(%1,%2);").arg(QString::number(index+1), QString::number(_currentPk)))) {
		qDebug() << q.lastError();
	}
}
