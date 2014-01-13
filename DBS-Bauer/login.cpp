#include "login.h"
#include "ui_login.h"
#include <QAbstractButton>
#include <QApplication>
#include <QDebug>
#include <QKeyEvent>

login::login(QWidget *parent) :
	QDialog(parent),
	ui(new Ui::login)
{
	ui->setupUi(this);
	//setWindowFlags(Qt::FramelessWindowHint);
	user = pass = "";
}

login::~login()
{
	delete ui;
}

void login::on_buttonBox_accepted()
{
	user = ui->Benutzer->text();
	pass = ui->Passwort->text();
	close();
}

void login::on_buttonBox_rejected()
{
	exit(0);
}

void login::keyPressEvent(QKeyEvent *e)
{
	if (e->key() != Qt::Key_Escape) {
		QDialog::keyPressEvent(e);
	}
}
