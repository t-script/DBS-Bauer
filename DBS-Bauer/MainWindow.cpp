#include "MainWindow.h"
#include "ui_MainWindow.h"
#include <QDebug>

MainWindow::MainWindow(QWidget *parent) :
	QMainWindow(parent),
	ui(new Ui::MainWindow)
{
	ui->setupUi(this);
}

MainWindow::~MainWindow()
{
	delete ui;
}

void MainWindow::on_actionStall_triggered()
{
	qDebug() << "Stall pressed.\n";
}

void MainWindow::on_actionAngestellter_triggered()
{
}

void MainWindow::on_actionTier_triggered()
{
}

void MainWindow::on_actionLager_triggered()
{
}

void MainWindow::on_actionFutter_triggered()
{
}

void MainWindow::on_actionMaschinen_triggered()
{
}

void MainWindow::on_actionD_nger_triggered()
{
}

void MainWindow::on_actionAcker_triggered()
{
}

void MainWindow::on_actionSaatgut_triggered()
{
}
