#include "maschinewidget.h"
#include "ui_maschinewidget.h"
#include "insertmaschinedialog.h"
#include <QtSql/QSqlDatabase>
#include <QDebug>
#include <QSqlError>
#include <QSqlQuery>
#include <QSqlQueryModel>
#include <QMessageBox>

MaschineWidget::MaschineWidget(QWidget *parent) :
	QWidget(parent),
	ui(new Ui::MaschineWidget)
{
	ui->setupUi(this);
	chronik = new QSqlQueryModel(ui->tableVerwendung);
	maschinen = new QSqlTableModel(ui->tableMaschine);
	maschinen->setTable("maschine");

	if(!maschinen->select()) {
		qDebug() << maschinen->lastError();
	}
	ui->tableMaschine->setModel(maschinen);
	ui->tableMaschine->setSelectionBehavior(QAbstractItemView::SelectRows);
	ui->tableMaschine->setSelectionMode(QAbstractItemView::SingleSelection);
	ui->tableMaschine->setEditTriggers(QAbstractItemView::NoEditTriggers);

	// PK verstecken
	ui->tableMaschine->hideColumn(0);
	ui->tableMaschine->hideColumn(1);
}

MaschineWidget::~MaschineWidget()
{
	delete chronik;
	delete maschinen;
	delete ui;
}

void MaschineWidget::on_tableMaschine_clicked(const QModelIndex &index)
{
	bool ok = false;
	currentPk = (maschinen->index(index.row(), 0)).data().toInt(&ok);

	if (currentPk <= 0 || !ok) {
		qDebug() << maschinen->lastError();
	} else {
		QSqlQuery q;
		if (!q.exec(QString("SELECT * FROM usp_MaschineChronik(%1)").arg(currentPk))) {
			qDebug() << q.lastError();
		}
		chronik->setQuery(q);
		ui->tableVerwendung->setModel(chronik);
		ui->tableVerwendung->hideColumn(0);
	}
}

void MaschineWidget::on_MaschineEinfuegen_clicked()
{
	InsertMaschineDialog d;
	d.setModal(true);
	d.exec();
	maschinen->select();
}

void MaschineWidget::on_MaschineTot_clicked()
{
	QSqlQuery q;
	if (!q.exec(QString("SELECT usp_DeleteMaschine(%1, 'f') ;").arg(QString::number(currentPk)))) {


		QMessageBox m;
		m.setText("Wenn sie fortfahren werden alle Einträge gelöscht die mit dieser Maschine in verbindung stehen.");
		m.setStandardButtons(QMessageBox::Yes | QMessageBox::No);
		m.setIcon(QMessageBox::Warning);
		m.setDefaultButton(QMessageBox::No);
		int ret = m.exec();
		switch (ret) {
		case QMessageBox::Yes:

			if (!q.exec(QString("SELECT usp_DeleteMaschine(%1, 't') ;").arg(QString::number(currentPk)))) {
				qDebug() << q.lastError(); //need more indent
			}
			break;
		default:
			break;
		}
	}
	maschinen->select();
}
