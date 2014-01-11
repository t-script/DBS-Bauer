#include "stallwidget.h"
#include "ui_stallwidget.h"
#include <QtSql/QSqlDatabase>
#include <QDebug>
#include <QSqlError>

StallWidget::StallWidget(QWidget *parent) :
	QWidget(parent),
	ui(new Ui::StallWidget)
{
	ui->setupUi(this);
    staelle = new QSqlTableModel(ui->tableStall);
    staelle->setTable("stall");
    if(staelle->select() != true)
    {
        qDebug() << staelle->lastError();
    }
    ui->tableStall->setModel(staelle);
    ui->tableStall->setSelectionBehavior(QAbstractItemView::SelectRows);
    ui->tableStall->setSelectionMode(QAbstractItemView::SingleSelection);
    ui->tableStall->setEditTriggers(QAbstractItemView::NoEditTriggers);

}

StallWidget::~StallWidget()
{
    delete staelle;
	delete ui;
}
