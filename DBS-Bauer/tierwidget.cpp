#include "tierwidget.h"
#include "ui_tierwidget.h"

TierWidget::TierWidget(QWidget *parent) :
	QWidget(parent),
	ui(new Ui::TierWidget)
{
	ui->setupUi(this);
}

TierWidget::~TierWidget()
{
	delete ui;
}
