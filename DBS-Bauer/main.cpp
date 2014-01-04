#include "MainWindow.h"
#include <QApplication>
#include <QtSql/QSqlDatabase>
#include <QDebug>

#define CONNECTION "Driver={PostgreSQL Unicode};SERVER=127.0.0.1;PORT=5432;UID=;PWD=;DATABASE=bauerdb;Trusted_Connection=YES"

int main(int argc, char *argv[])
{
	QApplication a(argc, argv);
	QSqlDatabase db;
	if (QSqlDatabase::isDriverAvailable("QODBC")) {
		db = QSqlDatabase::addDatabase("QODBC");
		db.setDatabaseName(CONNECTION);
		if (!db.open()){
			qDebug() << "can't open database\n";
			//return 0;
		}
	}
	MainWindow w;
	w.show();


	return a.exec();
}
