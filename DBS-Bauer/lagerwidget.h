#ifndef LAGERWIDGET_H
#define LAGERWIDGET_H

#include <QWidget>
#include <QSqlTableModel>

namespace Ui {
class LagerWidget;
}

class LagerWidget : public QWidget
{
	Q_OBJECT
	QSqlTableModel *lager;
	QSqlQueryModel *maschine;
	QSqlQueryModel *futter;
	QSqlQueryModel *duenger;
	QSqlQueryModel *saat;
	int currentPk;
public:
	explicit LagerWidget(QWidget *parent = 0);
	~LagerWidget();

private slots:
	void on_tableLager_clicked(const QModelIndex &index);

	void on_LagerEinfuegen_clicked();

	void on_LagerTot_clicked();

private:
	Ui::LagerWidget *ui;
	void SetupSubTables(const QModelIndex& index);
	void SetupMaschinen(const QModelIndex& index);
	void SetupFutter(const QModelIndex& index);
	void SetupDuenger(const QModelIndex& index);
	void SetupSaat(const QModelIndex& index);
};

#endif // LAGERWIDGET_H
