#include "tierwidget.h"
#include "ui_tierwidget.h"
#include <QtSql/QSqlDatabase>
#include <QDebug>
#include <QSqlError>

TierWidget::TierWidget(QWidget *parent) :
	QWidget(parent),
	ui(new Ui::TierWidget)
{
	ui->setupUi(this);
	tiere = new QSqlTableModel(ui->tableTier);
	tiere->setTable("tier");
	if(tiere->select() != true)
	{
		qDebug() << tiere->lastError();
	}
	ui->tableTier->setModel(tiere);
}

TierWidget::~TierWidget()
{
	delete tiere;
	delete ui;
}
