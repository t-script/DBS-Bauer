#include "angestellterwidget.h"
#include "ui_angestellterwidget.h"
#include <QtSql/QSqlDatabase>
#include <QDebug>
#include <QSqlError>

AngestellterWidget::AngestellterWidget(QWidget *parent) :
	QWidget(parent),
	ui(new Ui::AngestellterWidget)
{
	ui->setupUi(this);
    angestellten = new QSqlTableModel(ui->tableAngestellter);
    angestellten->setTable("angestellter");
    if(angestellten->select() != true)
    {
        qDebug() << angestellten->lastError();
    }
    ui->tableAngestellter->setModel(angestellten);
    ui->tableAngestellter->setSelectionBehavior(QAbstractItemView::SelectRows);
    ui->tableAngestellter->setSelectionMode(QAbstractItemView::SingleSelection);
    ui->tableAngestellter->setEditTriggers(QAbstractItemView::NoEditTriggers);
}

AngestellterWidget::~AngestellterWidget()
{
    delete angestellten;
	delete ui;
}
