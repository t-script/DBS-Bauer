#include "duengerwidget.h"
#include "ui_duengerwidget.h"
#include <QtSql/QSqlDatabase>
#include <QDebug>
#include <QSqlError>

DuengerWidget::DuengerWidget(QWidget *parent) :
	QWidget(parent),
	ui(new Ui::DuengerWidget)
{
	ui->setupUi(this);
    dunger = new QSqlTableModel(ui->tableDunger);
    dunger->setTable("duenger");
    if(dunger->select() != true)
    {
        qDebug() << dunger->lastError();
    }
    ui->tableDunger->setModel(dunger);
    ui->tableDunger->setSelectionBehavior(QAbstractItemView::SelectRows);
    ui->tableDunger->setSelectionMode(QAbstractItemView::SingleSelection);
    ui->tableDunger->setEditTriggers(QAbstractItemView::NoEditTriggers);
}

DuengerWidget::~DuengerWidget()
{
    delete dunger;
	delete ui;
}
