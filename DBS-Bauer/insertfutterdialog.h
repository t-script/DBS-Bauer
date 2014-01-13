#ifndef INSERTFUTTERDIALOG_H
#define INSERTFUTTERDIALOG_H

#include <QDialog>

namespace Ui {
class InsertFutterDialog;
}

class InsertFutterDialog : public QDialog
{
	Q_OBJECT

public:
	explicit InsertFutterDialog(QWidget *parent = 0);
	~InsertFutterDialog();

private slots:
	void on_buttonBox_accepted();

private:
	void SetupLager();
	Ui::InsertFutterDialog *ui;
};

#endif // INSERTFUTTERDIALOG_H
