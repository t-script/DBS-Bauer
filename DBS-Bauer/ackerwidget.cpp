#include "ackerwidget.h"
#include "ui_ackerwidget.h"
#include <QtSql/QSqlDatabase>
#include <QDebug>
#include <QSqlError>
#include <QSqlQuery>
#include <QSqlQueryModel>

AckerWidget::AckerWidget(QWidget *parent) :
	QWidget(parent),
	ui(new Ui::AckerWidget)
{
	ui->setupUi(this);
	aecker = new QSqlTableModel(ui->tableAcker);
	aecker->setTable("acker");
	daten = new QSqlQueryModel(ui->tableAckerDaten);

	if(aecker->select() != true) {
		qDebug() << aecker->lastError();
	}

	ui->tableAcker->setModel(aecker);
	ui->tableAcker->setSelectionBehavior(QAbstractItemView::SelectRows);
	ui->tableAcker->setSelectionMode(QAbstractItemView::SingleSelection);
	ui->tableAcker->setEditTriggers(QAbstractItemView::NoEditTriggers);

	// PK verstecken
	ui->tableAcker->hideColumn(0);
}

AckerWidget::~AckerWidget()
{
	delete daten;
	delete aecker;
	delete ui;
}

void AckerWidget::on_tableAcker_clicked(const QModelIndex &index)
{
	bool ok = false;
	int currentPk = (aecker->index(index.row(), 0)).data().toInt(&ok);

	if (currentPk <= 0 || !ok) {
		qDebug() << aecker->lastError();
	} else {
		QSqlQuery q;
		if (!q.exec(QString("SELECT * FROM usp_AckerDaten(%1)").arg(currentPk))) {
			qDebug() << q.lastError();
		}
		daten->setQuery(q);
		ui->tableAckerDaten->setModel(daten);
		ui->tableAckerDaten->hideColumn(0);
	}
}
