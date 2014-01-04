#include "maschinewidget.h"
#include "ui_maschinewidget.h"

MaschineWidget::MaschineWidget(QWidget *parent) :
	QWidget(parent),
	ui(new Ui::MaschineWidget)
{
	ui->setupUi(this);
}

MaschineWidget::~MaschineWidget()
{
	delete ui;
}
