#include "bauerexception.h"
#include <QtSql/QSqlDatabase>
#include <QDebug>
#include <QSqlError>

BauerException::BauerException(QString& error)
{
	m_msg = error;
}

BauerException::~BauerException() throw()
{

}

void BauerException::raise() const
{
	throw *this;
}

BauerException* BauerException::clone() const
{
	return new BauerException(*this);
}

QString BauerException::what()
{
	return m_msg;
}
