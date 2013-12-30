#include "futterwidget.h"
#include "ui_futterwidget.h"

FutterWidget::FutterWidget(QWidget *parent) :
	QWidget(parent),
	ui(new Ui::FutterWidget)
{
	ui->setupUi(this);
}

FutterWidget::~FutterWidget()
{
	delete ui;
}
