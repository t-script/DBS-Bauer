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

private:
	Ui::InsertTierDialog *ui;
};

#endif // INSERTTIERDIALOG_H
