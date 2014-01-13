#include "ackerwidget.h"
#include "ui_ackerwidget.h"
#include <QtSql/QSqlDatabase>
#include <QDebug>
#include <QSqlError>
#include <QSqlQuery>
#include <QSqlQueryModel>
#include <QMessageBox>

AckerWidget::AckerWidget(QWidget *parent) :
	QWidget(parent),
	ui(new Ui::AckerWidget)
{
	ui->setupUi(this);
	aecker = new QSqlTableModel(ui->tableAcker);
	aecker->setTable("acker");
	daten = new QSqlQueryModel(ui->tableAckerDaten);

	if(!aecker->select()) {
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
	currentPk = (aecker->index(index.row(), 0)).data().toInt(&ok);

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

void AckerWidget::on_AckerNeu_clicked()
{

}

void AckerWidget::on_AckerTot_clicked()
{
	QSqlQuery q;
	if (!q.exec(QString("SELECT usp_DeleteAcker(%1, 'f') ;").arg(QString::number(currentPk)))) {


		QMessageBox m;
		m.setText("Wenn sie fortfahren werden alle Einträge gelöscht die mit diesem Acker in verbindung stehen.");
		m.setStandardButtons(QMessageBox::Yes | QMessageBox::No);
		m.setIcon(QMessageBox::Warning);
		m.setDefaultButton(QMessageBox::No);
		int ret = m.exec();
		switch (ret) {
		case QMessageBox::Yes:

			if (!q.exec(QString("SELECT usp_DeleteAcker(%1, 't') ;").arg(QString::number(currentPk)))) {
				qDebug() << q.lastError(); //need more indent
			}
			break;
		default:
			break;
		}
	}
	aecker->select();
}
