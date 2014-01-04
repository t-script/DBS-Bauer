#include "saatgutwidget.h"
#include "ui_saatgutwidget.h"

SaatgutWidget::SaatgutWidget(QWidget *parent) :
	QWidget(parent),
	ui(new Ui::SaatgutWidget)
{
	ui->setupUi(this);
}

SaatgutWidget::~SaatgutWidget()
{
	delete ui;
}
