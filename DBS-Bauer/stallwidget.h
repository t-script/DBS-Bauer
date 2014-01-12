#ifndef STALLWIDGET_H
#define STALLWIDGET_H

#include <QWidget>
#include <QSqlTableModel>

namespace Ui {
class StallWidget;
}

class StallWidget : public QWidget
{
	Q_OBJECT
	QSqlTableModel *staelle;
	QSqlQueryModel *tiere;
	QSqlQueryModel *arbeiten;
	int currentPk;
public:
	explicit StallWidget(QWidget *parent = 0);
	~StallWidget();

private slots:
	void on_tableStall_clicked(const QModelIndex &index);

	void on_stalleinfuegen_clicked();

	void on_stalltot_clicked();

private:
	Ui::StallWidget *ui;

	void SetupSubTables(const QModelIndex& index);
	void SetupTiere(const QModelIndex& index);
	void SetupArbeiten(const QModelIndex& index);
};

#endif // STALLWIDGET_H
