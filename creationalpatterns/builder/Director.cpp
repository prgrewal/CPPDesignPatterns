#include "Director.hpp"
#include <iostream>


void Director::CreateTriangle(TriangleBuilder* builder) {
    builder->setTriangle();

    builder->buildVertexShader();

    builder->buildFragmentShader();

    builder->compileShaders();

    builder->buildLinkProgram();

    builder->buildVertices();

    builder->buildVertexArrayObject();

}
