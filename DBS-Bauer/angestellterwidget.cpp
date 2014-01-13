#include "angestellterwidget.h"
#include "ui_angestellterwidget.h"
#include "insertangestellterdialog.h"
#include <QtSql/QSqlDatabase>
#include <QDebug>
#include <QSqlError>
#include <QSqlQuery>
#include <QSqlQueryModel>
#include <QMessageBox>
#include "errordialog.h"

AngestellterWidget::AngestellterWidget(QWidget *parent) :
	QWidget(parent),
	ui(new Ui::AngestellterWidget)
{
	ui->setupUi(this);
	angestellten = new QSqlTableModel(ui->tableAngestellter);
	angestellten->setTable("angestellter");
	angestellten->setEditStrategy(QSqlTableModel::OnFieldChange);
	arbeiten = new QSqlQueryModel(ui->tableArbeit);

	if(angestellten->select() != true) {
		ErrorDialog() << angestellten->lastError();
	}

	ui->tableAngestellter->setModel(angestellten);
	ui->tableAngestellter->setSelectionBehavior(QAbstractItemView::SelectRows);
	ui->tableAngestellter->setSelectionMode(QAbstractItemView::SingleSelection);
	//ui->tableAngestellter->setEditTriggers(QAbstractItemView::NoEditTriggers);

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
	currentPk = (angestellten->index(index.row(), 0)).data().toInt(&ok);

	if (currentPk <= 0 || !ok) {
		ErrorDialog() << angestellten->lastError();
	} else {
		QSqlQuery q;
		if (!q.exec(QString("SELECT * FROM usp_AngestellterArbeiten(%1)").arg(currentPk))) {
			ErrorDialog() << q.lastError();
		}
		arbeiten->setQuery(q);
		ui->tableArbeit->setModel(arbeiten);
		ui->tableArbeit->hideColumn(0);
	}
}

void AngestellterWidget::on_AngestellterNeu_clicked()
{
	InsertAngestellterDialog d;
	d.setModal(true);
	d.exec();
	angestellten->select();
}

void AngestellterWidget::on_AngestellterTot_clicked()
{
	QSqlQuery q;
	q.prepare("SELECT usp_DeleteAngestellter(?, 'f');");
	q.bindValue(0,currentPk);
	if (!q.exec()) {
		QMessageBox m;
		m.setText("Wenn sie fortfahren werden alle Einträge gelöscht die mit diesem Angestellten in verbindung stehen.");
		m.setStandardButtons(QMessageBox::Yes | QMessageBox::No);
		m.setIcon(QMessageBox::Warning);
		m.setDefaultButton(QMessageBox::No);
		int ret = m.exec();
		switch (ret) {
		case QMessageBox::Yes:
			q.clear();
			q.prepare("SELECT usp_DeleteAngestellter(?, 't');");
			q.bindValue(0,currentPk);
			if (!q.exec()) {
				ErrorDialog() << q.lastError(); //need more indent
			}
			break;
		default:
			break;
		}
	}
	angestellten->select();
}
