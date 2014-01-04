#include "duengerwidget.h"
#include "ui_duengerwidget.h"

DuengerWidget::DuengerWidget(QWidget *parent) :
	QWidget(parent),
	ui(new Ui::DuengerWidget)
{
	ui->setupUi(this);
}

DuengerWidget::~DuengerWidget()
{
	delete ui;
}
