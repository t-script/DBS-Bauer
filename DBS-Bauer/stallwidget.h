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
public:
	explicit StallWidget(QWidget *parent = 0);
	~StallWidget();

private:
	Ui::StallWidget *ui;
};

#endif // STALLWIDGET_H
