#include "errordialog.h"
#include <QMessageBox>

ErrorDialog::ErrorDialog()
{

}

void ErrorDialog::show()
{
	QMessageBox m;
	m.setText(m_message);
	m.setIcon(QMessageBox::Information);
	m.exec();

}

void ErrorDialog::setMessage(QString &msg)
{
	m_message = msg;
}

void ErrorDialog::operator <<(const char* rhs)
{
	m_message = QString(rhs);
	this->show();
}

void ErrorDialog::operator <<(const QSqlError& rhs)
{
	m_message = rhs.text();
	this->show();
}
