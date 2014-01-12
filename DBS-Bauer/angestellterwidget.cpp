#include "angestellterwidget.h"
#include "ui_angestellterwidget.h"
#include <QtSql/QSqlDatabase>
#include <QDebug>
#include <QSqlError>
#include <QSqlQuery>
#include <QSqlQueryModel>

AngestellterWidget::AngestellterWidget(QWidget *parent) :
	QWidget(parent),
	ui(new Ui::AngestellterWidget)
{
	ui->setupUi(this);
	angestellten = new QSqlTableModel(ui->tableAngestellter);
	angestellten->setTable("angestellter");
	arbeiten = new QSqlQueryModel(ui->tableArbeit);

	if(angestellten->select() != true) {
		qDebug() << angestellten->lastError();
	}

	ui->tableAngestellter->setModel(angestellten);
	ui->tableAngestellter->setSelectionBehavior(QAbstractItemView::SelectRows);
	ui->tableAngestellter->setSelectionMode(QAbstractItemView::SingleSelection);
	ui->tableAngestellter->setEditTriggers(QAbstractItemView::NoEditTriggers);

	// PK verstecken
	ui->tableAngestellter->hideColumn(0);
}

AngestellterWidget::~AngestellterWidget()
{
	delete arbeiten;
	delete angestellten;
	delete ui;
}

void AngestellterWidget::on_tableAngestellter_clicked(const QModelIndex &index)
{
	bool ok = false;
	int currentPk = (angestellten->index(index.row(), 0)).data().toInt(&ok);

	if (currentPk <= 0 || !ok) {
		qDebug() << angestellten->lastError();
	} else {
		QSqlQuery q;
		if (!q.exec(QString("SELECT * FROM usp_AngestellterArbeiten(%1)").arg(currentPk))) {
			qDebug() << q.lastError();
		}
		arbeiten->setQuery(q);
		ui->tableArbeit->setModel(arbeiten);
		ui->tableArbeit->hideColumn(0);
	}
}
