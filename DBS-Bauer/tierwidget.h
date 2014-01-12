#ifndef TIERWIDGET_H
#define TIERWIDGET_H

#include <QWidget>
#include <QSqlTableModel>

namespace Ui {
class TierWidget;
}

class TierWidget : public QWidget
{
	Q_OBJECT
	QSqlTableModel *tiere;
	QSqlQueryModel *tierarzt;
	QSqlQueryModel *attribute;
	QSqlQueryModel *futter;
	int _currentPk;
public:
	explicit TierWidget(QWidget *parent = 0);
	~TierWidget();

private slots:
	void on_tableTier_clicked(const QModelIndex &index);

    void on_tableAttribute_clicked(const QModelIndex &index);

    void on_tableArzt_clicked(const QModelIndex &index);

    void on_tableFutterTier_clicked(const QModelIndex &index);

    void on_comboStall_activated(int index);

private:
	Ui::TierWidget *ui;
	void TierTableChanged(const QModelIndex& index);
	void SetupSubTables(const QModelIndex& index);
	void SetupStall(const QModelIndex& index);
	void SetupAttribute(const QModelIndex& index);
	void SetupTierarzt(const QModelIndex& index);
	void SetupFutterTier(const QModelIndex& index);

};

#endif // TIERWIDGET_H
