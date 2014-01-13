#ifndef INSERTACKERDIALOG_H
#define INSERTACKERDIALOG_H

#include <QDialog>

namespace Ui {
class InsertAckerDialog;
}

class InsertAckerDialog : public QDialog
{
	Q_OBJECT

public:
	explicit InsertAckerDialog(QWidget *parent = 0);
	~InsertAckerDialog();

private slots:
	void on_buttonBox_accepted();

private:
	Ui::InsertAckerDialog *ui;
};

#endif // INSERTACKERDIALOG_H
