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
public:
	explicit DuengerWidget(QWidget *parent = 0);
	~DuengerWidget();

private:
	Ui::DuengerWidget *ui;
};

#endif // DUENGERWIDGET_H
