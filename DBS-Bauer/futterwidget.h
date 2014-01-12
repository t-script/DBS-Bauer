#ifndef FUTTERWIDGET_H
#define FUTTERWIDGET_H

#include <QWidget>
#include <QSqlTableModel>

namespace Ui {
class FutterWidget;
}

class FutterWidget : public QWidget
{
	Q_OBJECT
	QSqlTableModel *futter;
	QSqlQueryModel *bestand;

public:
	explicit FutterWidget(QWidget *parent = 0);
	~FutterWidget();

private slots:
	void on_tableFutter_clicked(const QModelIndex &index);

private:
	Ui::FutterWidget *ui;
};

#endif // FUTTERWIDGET_H
