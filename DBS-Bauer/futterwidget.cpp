#include "futterwidget.h"
#include "ui_futterwidget.h"
#include <QtSql/QSqlDatabase>
#include <QDebug>
#include <QSqlError>

FutterWidget::FutterWidget(QWidget *parent) :
	QWidget(parent),
	ui(new Ui::FutterWidget)
{
	ui->setupUi(this);
    futterr = new QSqlTableModel(ui->tableFutter);
    futterr->setTable("futter");
    if(futterr->select() != true)
    {
        qDebug() << futterr->lastError();
    }
    ui->tableFutter->setModel(futterr);
    ui->tableFutter->setSelectionBehavior(QAbstractItemView::SelectRows);
    ui->tableFutter->setSelectionMode(QAbstractItemView::SingleSelection);
    ui->tableFutter->setEditTriggers(QAbstractItemView::NoEditTriggers);
}

FutterWidget::~FutterWidget()
{
    delete futterr;
	delete ui;
}
