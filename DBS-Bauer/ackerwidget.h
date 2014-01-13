#ifndef ACKERWIDGET_H
#define ACKERWIDGET_H

#include <QWidget>
#include <QSqlTableModel>

namespace Ui {
class AckerWidget;
}

class AckerWidget : public QWidget
{
	Q_OBJECT
	QSqlTableModel *aecker;
	QSqlQueryModel *daten;
public:
	explicit AckerWidget(QWidget *parent = 0);
	~AckerWidget();

private slots:
	void on_tableAcker_clicked(const QModelIndex &index);

	void on_AckerNeu_clicked();

	void on_AckerTot_clicked();

private:
	int currentPk;
	Ui::AckerWidget *ui;
};

#endif // ACKERWIDGET_H
