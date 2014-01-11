#include "ackerwidget.h"
#include "ui_ackerwidget.h"
#include <QtSql/QSqlDatabase>
#include <QDebug>
#include <QSqlError>

AckerWidget::AckerWidget(QWidget *parent) :
	QWidget(parent),
	ui(new Ui::AckerWidget)
{
	ui->setupUi(this);
    aecker = new QSqlTableModel(ui->tableAcker);
    aecker->setTable("acker");
    if(aecker->select() != true)
    {
        qDebug() << aecker->lastError();
    }
    ui->tableAcker->setModel(aecker);
    ui->tableAcker->setSelectionBehavior(QAbstractItemView::SelectRows);
    ui->tableAcker->setSelectionMode(QAbstractItemView::SingleSelection);
    ui->tableAcker->setEditTriggers(QAbstractItemView::NoEditTriggers);
}

AckerWidget::~AckerWidget()
{
    delete aecker;
	delete ui;
}
