#include "MainWindow.h"
#include <QApplication>
#include <QtSql/QSqlDatabase>
#include <QDebug>

#define CONNECTION "Driver={PostgreSQL Unicode};SERVER=127.0.0.1;PORT=5432;UID=baueradmin;PWD=bauer;DATABASE=bauerdb;Trusted_Connection=YES"

int main(int argc, char *argv[])
{
	QApplication a(argc, argv);
	QSqlDatabase db;
	if (QSqlDatabase::isDriverAvailable("QPSQL")) {
		db = QSqlDatabase::addDatabase("QPSQL");
		db.setHostName("localhost");
		db.setDatabaseName("bauerdb");
		db.setUserName("baueradmin");
		db.setPassword("bauer");
		if (!db.open()){
			qDebug() << "can't open database\n";
			//return 0;
		} else {
			qDebug() << "psql connection success\n";
		}
	} else {
		qDebug() << "Database Driver not available\n";

	}
	MainWindow w;
	w.show();


	return a.exec();
}
