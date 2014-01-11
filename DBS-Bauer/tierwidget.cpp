#include "tierwidget.h"
#include "ui_tierwidget.h"
#include <QtSql/QSqlDatabase>
#include <QDebug>
#include <QSqlError>
#include <QSqlQuery>

TierWidget::TierWidget(QWidget *parent) :
	QWidget(parent),
	ui(new Ui::TierWidget)
{
	ui->setupUi(this);
	tiere = new QSqlTableModel(ui->tableTier);
	tierarzt = new QSqlQueryModel(ui->tableArzt);
	tiere->setTable("tier");
	if(tiere->select() != true)
	{
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
	delete ui;
}

void TierWidget::on_tableTier_clicked(const QModelIndex &index)
{
	QModelIndex in= tiere->index(index.row(), 0);
	QVariant test = ui->tableTier->model()->data(in);
	QSqlQuery q(QString("SELECT * FROM usp_TierArztBesuche(%1)").arg(test.toString()));
	tierarzt->setQuery(q);
}
