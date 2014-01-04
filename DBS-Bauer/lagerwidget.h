#ifndef LAGERWIDGET_H
#define LAGERWIDGET_H

#include <QWidget>

namespace Ui {
class LagerWidget;
}

class LagerWidget : public QWidget
{
	Q_OBJECT

public:
	explicit LagerWidget(QWidget *parent = 0);
	~LagerWidget();

private:
	Ui::LagerWidget *ui;
};

#endif // LAGERWIDGET_H
