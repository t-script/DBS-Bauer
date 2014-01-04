#ifndef ACKERWIDGET_H
#define ACKERWIDGET_H

#include <QWidget>

namespace Ui {
class AckerWidget;
}

class AckerWidget : public QWidget
{
	Q_OBJECT

public:
	explicit AckerWidget(QWidget *parent = 0);
	~AckerWidget();

private:
	Ui::AckerWidget *ui;
};

#endif // ACKERWIDGET_H
