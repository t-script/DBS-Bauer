#include "MainWindow.h"
#include "ui_MainWindow.h"
#include "login.h"
#include <QDebug>
#include "errordialog.h"
#include <QSqlError>

MainWindow::MainWindow(QWidget *parent) :
	QMainWindow(parent),
	ui(new Ui::MainWindow)
{
	// login
	log = new login();
	log->setModal(true);
	log->setVisible(true);
	log->exec();
	setLogin(log->user, log->pass);

	// setup
	ui->setupUi(this);
	ui->actionBeenden->setShortcut(tr("CTRL+B"));
	connect(ui->actionBeenden, SIGNAL(triggered()), this, SLOT(close()));
}

MainWindow::~MainWindow()
{
	delete log;
	delete ui;
}

void MainWindow::setLogin(QString user, QString pass)
{
	if (QSqlDatabase::isDriverAvailable("QPSQL")) {
		db = QSqlDatabase::addDatabase("QPSQL");
		db.setHostName("localhost");
		db.setDatabaseName("bauerdb");
		db.setUserName(user);
		db.setPassword(pass);

		if (!db.open()){
			ErrorDialog() << "can't open database\n";
			QApplication::exit();
		} else {
			ErrorDialog() << "psql connection success\n";
		}
	} else {
		ErrorDialog() << "Database Driver not available. libqt5sql5-psql is probably not installed\n";
		QApplication::exit();
	}
}
