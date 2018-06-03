#include "abstractproducts.h"
#include <QPushButton>
#include <QApplication>
#include <QLabel>
#include <QCheckBox>

class Button: public element {
public:
    void Draw(QHBoxLayout* layout) {
        QPushButton *button = new QPushButton(this->Name());
        layout->addWidget(button);
    }
private:
    QString Name() {
        return "Button";
    }
};

class Label: public element {
public:
    void Draw(QHBoxLayout* layout) {
        QLabel* label = new QLabel();
        label->setFrameStyle(QFrame::Panel | QFrame::Sunken);
        label->setText(this->Name());
        label->setAlignment(Qt::AlignBottom | Qt::AlignLeft);
        label->setFixedHeight(20);
        label->setFixedWidth(100);
        layout->addWidget(label);
    }
private:
    QString Name() {
        return "Label";
    }
};

class Checkbox: public element {
public:
    void Draw(QHBoxLayout* layout) {
        QCheckBox* checkbox = new QCheckBox(this->Name());
        layout->addWidget(checkbox);
    }
private:
    QString Name() {
        return "Checkbox";
    }
};
