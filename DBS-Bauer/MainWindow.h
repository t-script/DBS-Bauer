#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
	Q_OBJECT
	
public:
	explicit MainWindow(QWidget *parent = 0);
	~MainWindow();
	
private slots:
	void on_actionStall_triggered();

	void on_actionAngestellter_triggered();

	void on_actionTier_triggered();

	void on_actionLager_triggered();

	void on_actionFutter_triggered();

	void on_actionMaschinen_triggered();

	void on_actionD_nger_triggered();

	void on_actionAcker_triggered();

	void on_actionSaatgut_triggered();

private:
	Ui::MainWindow *ui;
};

#endif // MAINWINDOW_H
