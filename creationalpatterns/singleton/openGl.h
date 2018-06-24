#import <Cocoa/Cocoa.h>
#import <OpenGL/OpenGL.h>
#include <OpenGL/gl3.h>
#ifndef OPENGL_H
#define OPENGL_H
class OpenGLInit {
private:
    static OpenGLInit *s_instance;
    OpenGLInit() {}
public:
    void setColor() {
        glClearColor(0.5f, 0.6f, 0.7f, 1.0f);
    }
    void setViewport(CGFloat windowWidth, CGFloat windowHeight) {
        glViewport(0, 0, windowWidth, windowHeight);
        glEnable(GL_DEPTH_TEST);
    }
    void setViewportResize(CGFloat windowWidth, CGFloat windowHeight) {
        glViewport(0, 0, windowWidth, windowHeight);
    }
    void clear() {
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    }
    static OpenGLInit *instance() {
        if (!s_instance)
            s_instance = new OpenGLInit;
        return s_instance;
    }
};

OpenGLInit* OpenGLInit::s_instance = 0;
#endif
