#ifndef UIFACTORY_H
#define UIFACTORY_H
#include "abstractproducts.h"
class uiFactory {
    public:
        enum UI_FACTORIES {
            SAMPLEA,
            SAMPLEB,
            SAMPLEC
        };
        virtual element* GetElement() = 0;
        virtual shape* GetShape() = 0;
        virtual ~uiFactory() { };

        static uiFactory* CreateFactory(UI_FACTORIES sample);
};


#endif // UIFACTORY_H
