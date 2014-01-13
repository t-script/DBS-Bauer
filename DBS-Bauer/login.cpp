#include "login.h"
#include "ui_login.h"
#include <QAbstractButton>
#include <QDebug>

login::login(QWidget *parent) :
	QDialog(parent),
	ui(new Ui::login)
{
	ui->setupUi(this);
	setWindowFlags(Qt::FramelessWindowHint);
}

login::~login()
{
	delete ui;
}

void login::on_buttonBox_clicked(QAbstractButton *button)
{
	if (button->text() == "&OK") {
		user = ui->Benutzer->text();
		pass = ui->Passwort->text();
	} else {
	}
}
