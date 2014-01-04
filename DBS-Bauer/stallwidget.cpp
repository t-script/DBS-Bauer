#include "stallwidget.h"
#include "ui_stallwidget.h"

StallWidget::StallWidget(QWidget *parent) :
	QWidget(parent),
	ui(new Ui::StallWidget)
{
	ui->setupUi(this);
}

StallWidget::~StallWidget()
{
	delete ui;
}
