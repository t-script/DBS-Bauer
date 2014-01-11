#include "lagerwidget.h"
#include "ui_lagerwidget.h"
#include <QtSql/QSqlDatabase>
#include <QDebug>
#include <QSqlError>

LagerWidget::LagerWidget(QWidget *parent) :
	QWidget(parent),
	ui(new Ui::LagerWidget)
{
	ui->setupUi(this);
    laeger = new QSqlTableModel(ui->tableLager);
    laeger->setTable("lager");
    if(laeger->select() != true)
    {
        qDebug() << laeger->lastError();
    }
    ui->tableLager->setModel(laeger);
    ui->tableLager->setSelectionBehavior(QAbstractItemView::SelectRows);
    ui->tableLager->setSelectionMode(QAbstractItemView::SingleSelection);
    ui->tableLager->setEditTriggers(QAbstractItemView::NoEditTriggers);
}

LagerWidget::~LagerWidget()
{
    delete laeger;
	delete ui;
}
