#include "angestellterwidget.h"
#include "ui_angestellterwidget.h"

AngestellterWidget::AngestellterWidget(QWidget *parent) :
	QWidget(parent),
	ui(new Ui::AngestellterWidget)
{
	ui->setupUi(this);
}

AngestellterWidget::~AngestellterWidget()
{
	delete ui;
}
