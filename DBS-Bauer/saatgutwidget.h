#ifndef SAATGUTWIDGET_H
#define SAATGUTWIDGET_H

#include <QWidget>
#include <QSqlTableModel>

namespace Ui {
class SaatgutWidget;
}

class SaatgutWidget : public QWidget
{
	Q_OBJECT
    QSqlTableModel *saatgutt;
public:
	explicit SaatgutWidget(QWidget *parent = 0);
	~SaatgutWidget();

private:
	Ui::SaatgutWidget *ui;
};

#endif // SAATGUTWIDGET_H
