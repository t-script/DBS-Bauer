#include "lagerwidget.h"
#include "ui_lagerwidget.h"

LagerWidget::LagerWidget(QWidget *parent) :
	QWidget(parent),
	ui(new Ui::LagerWidget)
{
	ui->setupUi(this);
}

LagerWidget::~LagerWidget()
{
	delete ui;
}
