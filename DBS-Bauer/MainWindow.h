#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QtSql/QSqlDatabase>

namespace Ui {
class MainWindow;
}
class login;

class MainWindow : public QMainWindow
{
	Q_OBJECT
	login* log;
public:
	QSqlDatabase db;
	explicit MainWindow(QWidget *parent = 0);
	~MainWindow();

private slots:

private:
	Ui::MainWindow *ui;
	void setLogin(QString user, QString pass);
};

#endif // MAINWINDOW_H
