#include "mainwindow.h"
#include "uifactory.h"
#include <QPushButton>
#include <QApplication>
#include <QTextStream>
#include <QHBoxLayout>

int main(int argc, char *argv[]) {
    QApplication a(argc, argv);
    MainWindow w;
    QTextStream out(stdout);

    QWidget* window = new QWidget;
    QHBoxLayout* layout = new QHBoxLayout;

    uiFactory* uiFactory = uiFactory::CreateFactory(uiFactory::UI_FACTORIES::SAMPLEA);
    uiFactory->GetElement()->Draw(layout);
    uiFactory->GetShape()->Draw(layout);
    delete uiFactory->GetElement();
    delete uiFactory->GetShape();

    uiFactory = uiFactory::CreateFactory(uiFactory::UI_FACTORIES::SAMPLEB);
    uiFactory->GetElement()->Draw(layout);
    uiFactory->GetShape()->Draw(layout);
    delete uiFactory->GetElement();
    delete uiFactory->GetShape();

    uiFactory = uiFactory::CreateFactory(uiFactory::UI_FACTORIES::SAMPLEC);
    uiFactory->GetElement()->Draw(layout);
    uiFactory->GetShape()->Draw(layout);
    delete uiFactory->GetElement();
    delete uiFactory->GetShape();
    delete uiFactory;

    window->setLayout(layout);

    w.setCentralWidget(window);
    w.show();

    return a.exec();
}
