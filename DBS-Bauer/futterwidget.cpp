#include "futterwidget.h"
#include "ui_futterwidget.h"
#include <QtSql/QSqlDatabase>
#include <QDebug>
#include <QSqlError>
#include <QSqlQueryModel>
#include <QSqlQuery>

FutterWidget::FutterWidget(QWidget *parent) :
	QWidget(parent),
	ui(new Ui::FutterWidget)
{
	ui->setupUi(this);
	futter = new QSqlTableModel(ui->tableFutter);
	bestand = new QSqlQueryModel(ui->tableFutterBestand);
	futter->setTable("futter");
	if(!futter->select())
	{
		qDebug() << futter->lastError();
	}
	ui->tableFutter->setModel(futter);
	ui->tableFutter->setSelectionBehavior(QAbstractItemView::SelectRows);
	ui->tableFutter->setSelectionMode(QAbstractItemView::SingleSelection);
	ui->tableFutter->setEditTriggers(QAbstractItemView::NoEditTriggers);

	// PK verstecken
	ui->tableFutter->hideColumn(0);
}

FutterWidget::~FutterWidget()
{
	delete bestand;
	delete futter;
	delete ui;
}

void FutterWidget::on_tableFutter_clicked(const QModelIndex &index)
{
	bool ok = false;
	int currentPk = (futter->index(index.row(), 0)).data().toInt(&ok);

	if (currentPk <= 0 || !ok) {
		qDebug() << futter->lastError();
	} else {
		QSqlQuery q;
		if (!q.exec(QString("SELECT * FROM usp_FutterBestand(%1)").arg(currentPk))) {
			qDebug() << q.lastError();
		}
		bestand->setQuery(q);
		ui->tableFutterBestand->setModel(bestand);
		ui->tableFutterBestand->hideColumn(0);
	}
}
