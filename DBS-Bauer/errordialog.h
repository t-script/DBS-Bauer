#ifndef ERRORDIALOG_H
#define ERRORDIALOG_H
#include <QtCore>
#include <QSqlError>

class ErrorDialog
{
public:
	ErrorDialog();
	void show();
	void setMessage(QString& msg);
	void operator <<(const char* rhs);
	void operator <<(const QSqlError& rhs);
private:
	QString m_message;
};

#endif // ERRORDIALOG_H
