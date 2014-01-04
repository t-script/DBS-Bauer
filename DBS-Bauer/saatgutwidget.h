#ifndef SAATGUTWIDGET_H
#define SAATGUTWIDGET_H

#include <QWidget>

namespace Ui {
class SaatgutWidget;
}

class SaatgutWidget : public QWidget
{
	Q_OBJECT

public:
	explicit SaatgutWidget(QWidget *parent = 0);
	~SaatgutWidget();

private:
	Ui::SaatgutWidget *ui;
};

#endif // SAATGUTWIDGET_H
