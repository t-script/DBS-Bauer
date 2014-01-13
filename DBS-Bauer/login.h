#ifndef LOGIN_H
#define LOGIN_H

#include <QDialog>

namespace Ui {
class login;
}
class QAbstractButton;
class MainWindow;

class login : public QDialog
{
	Q_OBJECT
	friend class MainWindow;
public:
    explicit login(QWidget *parent = 0);
    ~login();

private slots:
	void on_buttonBox_accepted();

	void on_buttonBox_rejected();

protected:
	virtual void keyPressEvent(QKeyEvent *);

private:
    Ui::login *ui;
    QString user, pass;
};

#endif // LOGIN_H
