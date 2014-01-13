#ifndef INSERTLAGERDIALOG_H
#define INSERTLAGERDIALOG_H

#include <QDialog>

namespace Ui {
class InsertLagerDialog;
}

class InsertLagerDialog : public QDialog
{
	Q_OBJECT

public:
	explicit InsertLagerDialog(QWidget *parent = 0);
	~InsertLagerDialog();

private slots:
	void on_buttonBox_accepted();

private:
	Ui::InsertLagerDialog *ui;
};

#endif // INSERTLAGERDIALOG_H
