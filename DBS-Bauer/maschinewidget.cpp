#include "maschinewidget.h"
#include "ui_maschinewidget.h"
#include <QtSql/QSqlDatabase>
#include <QDebug>
#include <QSqlError>

MaschineWidget::MaschineWidget(QWidget *parent) :
	QWidget(parent),
	ui(new Ui::MaschineWidget)
{
	ui->setupUi(this);
    maschinen = new QSqlTableModel(ui->tableMaschine);
    maschinen->setTable("maschine");
    if(maschinen->select() != true)
    {
        qDebug() << maschinen->lastError();
    }
    ui->tableMaschine->setModel(maschinen);
    ui->tableMaschine->setSelectionBehavior(QAbstractItemView::SelectRows);
    ui->tableMaschine->setSelectionMode(QAbstractItemView::SingleSelection);
    ui->tableMaschine->setEditTriggers(QAbstractItemView::NoEditTriggers);
}

MaschineWidget::~MaschineWidget()
{
    delete maschinen;
	delete ui;
}
