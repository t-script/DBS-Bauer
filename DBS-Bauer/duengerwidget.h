#ifndef DUENGERWIDGET_H
#define DUENGERWIDGET_H

#include <QWidget>

namespace Ui {
class DuengerWidget;
}

class DuengerWidget : public QWidget
{
	Q_OBJECT

public:
	explicit DuengerWidget(QWidget *parent = 0);
	~DuengerWidget();

private:
	Ui::DuengerWidget *ui;
};

#endif // DUENGERWIDGET_H
