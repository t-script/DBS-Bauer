#-------------------------------------------------
#
# Project created by QtCreator 2013-12-17T14:31:33
#
#-------------------------------------------------

QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = DBS-Bauer
TEMPLATE = app


SOURCES += main.cpp\
        MainWindow.cpp \
    tierwidget.cpp \
    futterwidget.cpp

HEADERS  += MainWindow.h \
    tierwidget.h \
    futterwidget.h

FORMS    += MainWindow.ui \
    tierwidget.ui \
    futterwidget.ui
