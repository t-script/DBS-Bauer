#ifndef INSERTDUENGERDIALOG_H
#define INSERTDUENGERDIALOG_H

#include <QDialog>

namespace Ui {
class InsertDuengerDialog;
}

class InsertDuengerDialog : public QDialog
{
	Q_OBJECT

public:
	explicit InsertDuengerDialog(QWidget *parent = 0);
	~InsertDuengerDialog();

private slots:
	void on_buttonBox_accepted();

private:
	void SetupLager();
	Ui::InsertDuengerDialog *ui;
};

#endif // INSERTDUENGERDIALOG_H
