#ifndef Director_hpp
#define Director_hpp
#include "TriangleBuilder.hpp"
class Director {
public:
    void CreateTriangle(TriangleBuilder* builder);
    ~Director() {};
};

#endif
