#ifndef INSERTTIERDIALOG_H
#define INSERTTIERDIALOG_H

#include <QDialog>

namespace Ui {
class InsertTierDialog;
}

class InsertTierDialog : public QDialog
{
	Q_OBJECT

public:
	explicit InsertTierDialog(QWidget *parent = 0);
	~InsertTierDialog();

private slots:
	void on_buttonBox_accepted();

private:
	void SetupTierart();
	void SetupFutter();
	void SetupStall();

	Ui::InsertTierDialog *ui;
};

#endif // INSERTTIERDIALOG_H
