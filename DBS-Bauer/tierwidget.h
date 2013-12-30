#ifndef TIERWIDGET_H
#define TIERWIDGET_H

#include <QWidget>

namespace Ui {
class TierWidget;
}

class TierWidget : public QWidget
{
	Q_OBJECT

public:
	explicit TierWidget(QWidget *parent = 0);
	~TierWidget();

private:
	Ui::TierWidget *ui;
};

#endif // TIERWIDGET_H
