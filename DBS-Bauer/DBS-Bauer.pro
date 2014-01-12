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
    inserttierdialog.cpp

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
    inserttierdialog.h

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
    inserttierdialog.ui

unix: QMAKE_CXXFLAGS += -std=c++11
