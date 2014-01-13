#-------------------------------------------------
#
# Project created by QtCreator 2013-12-17T14:31:33
#
#-------------------------------------------------

QT       += core gui sql

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = DBS-Bauer
TEMPLATE = app


SOURCES += main.cpp\
	MainWindow.cpp \
    stallwidget.cpp \
    tierwidget.cpp \
    maschinewidget.cpp \
    futterwidget.cpp \
    lagerwidget.cpp \
    ackerwidget.cpp \
    duengerwidget.cpp \
    saatgutwidget.cpp \
    angestellterwidget.cpp \
    bauerexception.cpp \
    login.cpp \
    inserttierdialog.cpp \
    insertstalldialog.cpp \
    insertfutterdialog.cpp \
    insertmaschinedialog.cpp \
    insertlagerdialog.cpp \
    insertackerdialog.cpp \
    insertduengerdialog.cpp \
    insertsaatgutdialog.cpp \
    insertangestellterdialog.cpp \
    errordialog.cpp

HEADERS  += MainWindow.h \
    stallwidget.h \
    tierwidget.h \
    maschinewidget.h \
    futterwidget.h \
    lagerwidget.h \
    ackerwidget.h \
    duengerwidget.h \
    saatgutwidget.h \
    angestellterwidget.h \
    bauerexception.h \
    login.h \
    inserttierdialog.h \
    insertstalldialog.h \
    insertfutterdialog.h \
    insertmaschinedialog.h \
    insertlagerdialog.h \
    insertackerdialog.h \
    insertduengerdialog.h \
    insertsaatgutdialog.h \
    insertangestellterdialog.h \
    errordialog.h

FORMS    += MainWindow.ui \
    stallwidget.ui \
    tierwidget.ui \
    maschinewidget.ui \
    futterwidget.ui \
    lagerwidget.ui \
    ackerwidget.ui \
    duengerwidget.ui \
    saatgutwidget.ui \
    angestellterwidget.ui \
    login.ui \
    inserttierdialog.ui \
    insertstalldialog.ui \
    insertfutterdialog.ui \
    insertmaschinedialog.ui \
    insertlagerdialog.ui \
    insertackerdialog.ui \
    insertduengerdialog.ui \
    insertsaatgutdialog.ui \
    insertangestellterdialog.ui

unix: QMAKE_CXXFLAGS += -std=c++11
