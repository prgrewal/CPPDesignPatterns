#ifndef TriangleBuilder_hpp
#define TriangleBuilder_hpp
#include "Triangle.hpp"
#import <vector>
using namespace std;
class TriangleBuilder {
public:
    virtual void buildVertexShader() = 0;
    virtual void buildFragmentShader() = 0;
    virtual void setTriangle() = 0;
    virtual void buildVertices() = 0;
    virtual void getTriangle() = 0;
    virtual void compileShaders() = 0;
    virtual void buildLinkProgram() = 0;
    virtual void buildVertexArrayObject() = 0;
    virtual ~TriangleBuilder(){
        delete this->triangle;
    };
    Triangle* triangle;
};

#endif
