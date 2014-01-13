#include "futterwidget.h"
#include "ui_futterwidget.h"
#include "insertfutterdialog.h"
#include <QtSql/QSqlDatabase>
#include <QDebug>
#include <QSqlError>
#include <QSqlQueryModel>
#include <QSqlQuery>
#include <QMessageBox>
#include "errordialog.h"

FutterWidget::FutterWidget(QWidget *parent) :
	QWidget(parent),
	ui(new Ui::FutterWidget)
{
	ui->setupUi(this);
	futter = new QSqlTableModel(ui->tableFutter);
	bestand = new QSqlQueryModel(ui->tableFutterBestand);
	futter->setTable("futter");
	futter->setEditStrategy(QSqlTableModel::OnFieldChange);
	if(!futter->select())
	{
		ErrorDialog() << futter->lastError();
	}
	ui->tableFutter->setModel(futter);
	ui->tableFutter->setSelectionBehavior(QAbstractItemView::SelectRows);
	ui->tableFutter->setSelectionMode(QAbstractItemView::SingleSelection);

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
	currentPk = (futter->index(index.row(), 0)).data().toInt(&ok);

	if (currentPk <= 0 || !ok) {
		ErrorDialog() << futter->lastError();
	} else {
		QSqlQuery q;
		if (!q.exec(QString("SELECT * FROM usp_FutterBestand(%1)").arg(currentPk))) {
			ErrorDialog() << q.lastError();
		}
		bestand->setQuery(q);
		ui->tableFutterBestand->setModel(bestand);
		ui->tableFutterBestand->hideColumn(0);
	}
}

void FutterWidget::on_futtereinfuegen_clicked()
{
	InsertFutterDialog d;
	d.setModal(true);
	d.exec();
	futter->select();
}

void FutterWidget::on_futtertot_clicked()
{
	QSqlQuery q;
	if (!q.exec(QString("SELECT usp_DeleteFutter(%1, 'f') ;").arg(QString::number(currentPk)))) {


		QMessageBox m;
		m.setText("Wenn sie fortfahren werden alle Einträge gelöscht die mit diesem Futter in verbindung stehen.");
		m.setStandardButtons(QMessageBox::Yes | QMessageBox::No);
		m.setIcon(QMessageBox::Warning);
		m.setDefaultButton(QMessageBox::No);
		int ret = m.exec();
		switch (ret) {
		case QMessageBox::Yes:

			if (!q.exec(QString("SELECT usp_DeleteFutter(%1, 't') ;").arg(QString::number(currentPk)))) {
				ErrorDialog() << q.lastError(); //need more indent
			}
			break;
		default:
			break;
		}
	}
	futter->select();
}
