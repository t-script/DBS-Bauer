#include "MainWindow.h"
#include "ui_MainWindow.h"
#include <QDebug>
#include "errordialog.h"

MainWindow::MainWindow(QWidget *parent) :
	QMainWindow(parent),
	ui(new Ui::MainWindow)
{
	connectDb();
	ui->setupUi(this);
	ui->actionBeenden->setShortcut(tr("CTRL+B"));
	connect(ui->actionBeenden, SIGNAL(triggered()), this, SLOT(close()));
}

MainWindow::~MainWindow()
{
	delete ui;
}

void MainWindow::connectDb()
{
	if (QSqlDatabase::isDriverAvailable("QPSQL")) {
		db = QSqlDatabase::addDatabase("QPSQL");
		db.setHostName("localhost");
		db.setDatabaseName("bauerdb");
		db.setUserName("baueradmin");
		db.setPassword("bauer");
		if (!db.open()){
			ErrorDialog() << "can't open database\n";
			//return 0;
		} else {
			ErrorDialog() << "psql connection success\n";
		}
	} else {
		ErrorDialog() << "Database Driver not available. libqt5sql5-psql is probably not installed\n";

	}

}
