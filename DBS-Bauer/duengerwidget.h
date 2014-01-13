#ifndef DUENGERWIDGET_H
#define DUENGERWIDGET_H

#include <QWidget>
#include <QSqlTableModel>

namespace Ui {
class DuengerWidget;
}

class DuengerWidget : public QWidget
{
	Q_OBJECT
	QSqlTableModel *dunger;
	QSqlQueryModel *bestand;
public:
	explicit DuengerWidget(QWidget *parent = 0);
	~DuengerWidget();

private slots:
	void on_tableDunger_clicked(const QModelIndex &index);

	void on_DuengerNeu_clicked();

	void on_DuengerTot_clicked();

private:
	int currentPk;
	Ui::DuengerWidget *ui;
};

#endif // DUENGERWIDGET_H
