#ifndef SAATGUTWIDGET_H
#define SAATGUTWIDGET_H

#include <QWidget>
#include <QSqlTableModel>

namespace Ui {
class SaatgutWidget;
}

class SaatgutWidget : public QWidget
{
	Q_OBJECT
	QSqlTableModel *saatgut;
	QSqlQueryModel *bestand;
public:
	explicit SaatgutWidget(QWidget *parent = 0);
	~SaatgutWidget();

private slots:
	void on_tableSaagut_clicked(const QModelIndex &index);

	void on_SaatgutNeu_clicked();

	void on_SaatgutTot_clicked();

private:
	int currentPk;
	Ui::SaatgutWidget *ui;
};

#endif // SAATGUTWIDGET_H
