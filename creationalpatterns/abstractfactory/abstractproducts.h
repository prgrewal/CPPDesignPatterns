#ifndef ABSTRACTPRODUCTS_H
#define ABSTRACTPRODUCTS_H
#include <QString>
#include <QWidget>
#include "mainwindow.h"
#include <QHBoxLayout>
class element {
public:
    virtual void Draw(QHBoxLayout*) = 0;
    virtual ~element() { };
private:
    virtual QString Name() = 0;
};

class shape {
public:
    virtual void Draw(QHBoxLayout*) = 0;
    virtual ~shape() { };
private:
    virtual QString Name() = 0;
};


#endif // ABSTRACTPRODUCTS_H
