#ifndef INSERTSAATGUTDIALOG_H
#define INSERTSAATGUTDIALOG_H

#include <QDialog>

namespace Ui {
class InsertSaatgutDialog;
}

class InsertSaatgutDialog : public QDialog
{
	Q_OBJECT

public:
	explicit InsertSaatgutDialog(QWidget *parent = 0);
	~InsertSaatgutDialog();

private slots:
	void on_buttonBox_2_accepted();

private:
	void SetupLager();
	Ui::InsertSaatgutDialog *ui;
};

#endif // INSERTSAATGUTDIALOG_H
