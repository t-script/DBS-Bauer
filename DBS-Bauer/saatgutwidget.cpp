#include "saatgutwidget.h"
#include "ui_saatgutwidget.h"
#include <QtSql/QSqlDatabase>
#include <QDebug>
#include <QSqlError>

SaatgutWidget::SaatgutWidget(QWidget *parent) :
	QWidget(parent),
	ui(new Ui::SaatgutWidget)
{
	ui->setupUi(this);
    saatgutt = new QSqlTableModel(ui->tableSaagut);
    saatgutt->setTable("saatgut");
    if(saatgutt->select() != true)
    {
        qDebug() << saatgutt->lastError();
    }
    ui->tableSaagut->setModel(saatgutt);
    ui->tableSaagut->setSelectionBehavior(QAbstractItemView::SelectRows);
    ui->tableSaagut->setSelectionMode(QAbstractItemView::SingleSelection);
    ui->tableSaagut->setEditTriggers(QAbstractItemView::NoEditTriggers);
}

SaatgutWidget::~SaatgutWidget()
{
    delete saatgutt;
	delete ui;
}
