#ifndef FUTTERWIDGET_H
#define FUTTERWIDGET_H

#include <QWidget>

namespace Ui {
class FutterWidget;
}

class FutterWidget : public QWidget
{
	Q_OBJECT

public:
	explicit FutterWidget(QWidget *parent = 0);
	~FutterWidget();

private:
	Ui::FutterWidget *ui;
};

#endif // FUTTERWIDGET_H
