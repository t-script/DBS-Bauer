#ifndef MASCHINEWIDGET_H
#define MASCHINEWIDGET_H

#include <QWidget>
#include <QSqlTableModel>
#include <QSqlTableModel>

namespace Ui {
class MaschineWidget;
}

class MaschineWidget : public QWidget
{
	Q_OBJECT
	QSqlTableModel *maschinen;
	QSqlQueryModel *chronik;
public:
	explicit MaschineWidget(QWidget *parent = 0);
	~MaschineWidget();

private slots:
	void on_tableMaschine_clicked(const QModelIndex &index);

	void on_MaschineEinfuegen_clicked();

	void on_MaschineTot_clicked();

private:
	int currentPk;
	Ui::MaschineWidget *ui;
};

#endif // MASCHINEWIDGET_H
