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
public:
	explicit MaschineWidget(QWidget *parent = 0);
	~MaschineWidget();

private:
	Ui::MaschineWidget *ui;
};

#endif // MASCHINEWIDGET_H
