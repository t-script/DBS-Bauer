#ifndef INSERTMASCHINEDIALOG_H
#define INSERTMASCHINEDIALOG_H

#include <QDialog>

namespace Ui {
class InsertMaschineDialog;
}

class InsertMaschineDialog : public QDialog
{
	Q_OBJECT

public:
	explicit InsertMaschineDialog(QWidget *parent = 0);
	~InsertMaschineDialog();

private slots:
	void on_buttonBox_accepted();

private:
	void SetupLager();
	Ui::InsertMaschineDialog *ui;
};

#endif // INSERTMASCHINEDIALOG_H
