#include "abstractproducts.h"
#include <QRectF>
#include <QPainter>
#include <QLabel>
#include <QColor>
#include <QBrush>

class Rectangle: public shape {
public:
    void Draw(QHBoxLayout* layout) {
        QRectF rectangle(10.0, 20.0, 80.0, 60.0);
        QLabel* label = new QLabel();
        label->setFrameStyle(QFrame::Panel | QFrame::Sunken);
        label->setText(this->Name());
        label->setAlignment(Qt::AlignBottom | Qt::AlignLeft);
        label->setFixedHeight(100);
        QPixmap pixmap(100,100);
        pixmap.fill(QColor("transparent"));
        QPainter painter(&pixmap);
        QColor yellow("#f0d048");
        Qt::BrushStyle style = Qt::SolidPattern;
        QBrush brush(yellow, style);
        painter.setBrush(brush);
        painter.drawRect(rectangle);
        label->setPixmap(pixmap);
        layout->addWidget(label);
    }
private:
    QString Name() {
        return "Rectangle";
    }
};

class Circle: public shape {
public:
    void Draw(QHBoxLayout* layout) {
        QRectF rectangle(10.0, 20.0, 60.0, 60.0);
        QLabel* label = new QLabel();
        label->setFrameStyle(QFrame::Panel | QFrame::Sunken);
        label->setText(this->Name());
        label->setAlignment(Qt::AlignBottom | Qt::AlignLeft);
        label->setFixedHeight(100);
        QPixmap pixmap(100,100);
        pixmap.fill(QColor("transparent"));
        QPainter painter(&pixmap);
        QColor yellow("#f0d048");
        Qt::BrushStyle style = Qt::SolidPattern;
        QBrush brush(yellow, style);
        painter.setBrush(brush);
        painter.drawEllipse(rectangle);
        label->setPixmap(pixmap);
        layout->addWidget(label);
    }
private:
    QString Name() {
        return "Circle";
    }
};

class Triangle: public shape {
public:
    void Draw(QHBoxLayout* layout) {
        QRectF rect = QRectF(0, 0, 100, 100);
        QPainterPath path;
        path.moveTo(rect.left() + (rect.width() / 2), rect.top());
        path.lineTo(rect.bottomLeft());
        path.lineTo(rect.bottomRight());
        path.lineTo(rect.left() + (rect.width() / 2), rect.top());
        QLabel* label = new QLabel();
        label->setFrameStyle(QFrame::Panel | QFrame::Sunken);
        label->setText(this->Name());
        label->setAlignment(Qt::AlignBottom | Qt::AlignLeft);
        label->setFixedHeight(100);
        QPixmap pixmap(100,100);
        pixmap.fill(QColor("transparent"));
        QPainter painter(&pixmap);
        QColor yellow("#f0d048");
        Qt::BrushStyle style = Qt::SolidPattern;
        QBrush brush(yellow, style);
        painter.fillPath(path, brush);
        label->setPixmap(pixmap);
        layout->addWidget(label);
    }
private:
    QString Name() {
        return "Triangle";
    }
};
