#include "ackerwidget.h"
#include "ui_ackerwidget.h"

AckerWidget::AckerWidget(QWidget *parent) :
	QWidget(parent),
	ui(new Ui::AckerWidget)
{
	ui->setupUi(this);
}

AckerWidget::~AckerWidget()
{
	delete ui;
}
