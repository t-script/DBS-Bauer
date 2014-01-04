#ifndef MASCHINEWIDGET_H
#define MASCHINEWIDGET_H

#include <QWidget>

namespace Ui {
class MaschineWidget;
}

class MaschineWidget : public QWidget
{
	Q_OBJECT

public:
	explicit MaschineWidget(QWidget *parent = 0);
	~MaschineWidget();

private:
	Ui::MaschineWidget *ui;
};

#endif // MASCHINEWIDGET_H
