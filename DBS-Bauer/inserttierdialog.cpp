#include "inserttierdialog.h"
#include "ui_inserttierdialog.h"

InsertTierDialog::InsertTierDialog(QWidget *parent) :
	QDialog(parent),
	ui(new Ui::InsertTierDialog)
{
	ui->setupUi(this);
}

InsertTierDialog::~InsertTierDialog()
{
	delete ui;
}
