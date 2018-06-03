#include "uifactory.h"
#include "elements.cpp"
#include "shapes.cpp"

class FactoryA: public uiFactory {
public:
    element* GetElement() {
        return new Button();
    }

    shape* GetShape() {
        return new Rectangle();
    }
};

class FactoryB: public uiFactory {
public:
    element* GetElement() {
        return new Label();
    }

    shape* GetShape() {
        return new Circle();
    }
};

class FactoryC: public uiFactory {
public:
    element* GetElement() {
        return new Checkbox();
    }

    shape* GetShape() {
        return new Triangle();
    }
};

uiFactory* uiFactory::CreateFactory(UI_FACTORIES sample) {
    uiFactory* uiFactory;
    if (sample == UI_FACTORIES::SAMPLEA) {
        uiFactory = new FactoryA();
    }
    if (sample == UI_FACTORIES::SAMPLEB) {
        uiFactory = new FactoryB();
    }
    if (sample == UI_FACTORIES::SAMPLEC) {
        uiFactory = new FactoryC();
    }
    return uiFactory;
}
