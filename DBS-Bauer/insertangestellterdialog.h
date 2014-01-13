#ifndef INSERTANGESTELLTERDIALOG_H
#define INSERTANGESTELLTERDIALOG_H

#include <QDialog>

namespace Ui {
class InsertAngestellterDialog;
}

class InsertAngestellterDialog : public QDialog
{
	Q_OBJECT

public:
	explicit InsertAngestellterDialog(QWidget *parent = 0);
	~InsertAngestellterDialog();

private slots:
	void on_buttonBox_accepted();

private:
	Ui::InsertAngestellterDialog *ui;
};

#endif // INSERTANGESTELLTERDIALOG_H
