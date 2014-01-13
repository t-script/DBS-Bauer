#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QtSql/QSqlDatabase>

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
	Q_OBJECT
public:
	QSqlDatabase db;
	explicit MainWindow(QWidget *parent = 0);
	~MainWindow();
private slots:


private:
	void connectDb();
	Ui::MainWindow *ui;
};

#endif // MAINWINDOW_H
