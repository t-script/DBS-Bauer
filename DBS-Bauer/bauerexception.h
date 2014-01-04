#ifndef BAUEREXCEPTION_H
#define BAUEREXCEPTION_H

#include <QException>
#include <QString>

class BauerException : public QException
{
public:
	BauerException(QString& error);
	virtual ~BauerException() throw();
	void raise() const;
	BauerException* clone() const;
	QString what();
private:
	QString m_msg;

};

#endif // BAUEREXCEPTION_H
