#ifndef INSERTSTALLDIALOG_H
#define INSERTSTALLDIALOG_H

#include <QDialog>

namespace Ui {
class InsertStallDialog;
}

class InsertStallDialog : public QDialog
{
	Q_OBJECT

public:
	explicit InsertStallDialog(QWidget *parent = 0);
	~InsertStallDialog();

private slots:
	void on_buttonBox_accepted();

private:
	Ui::InsertStallDialog *ui;
};

#endif // INSERTSTALLDIALOG_H
