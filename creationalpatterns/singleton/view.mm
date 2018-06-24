#import <Foundation/Foundation.h>
#import "view.h"
#include <iostream>
#include "openGl.h"

using namespace std;

static View* sharedView = nil;
@implementation View
// Initialize
- (id) initWithFrame: (NSRect) frame {
    running = true;
    
    int samples = 0;
    
    NSOpenGLPixelFormatAttribute windowedAttrs[] =
    {
        NSOpenGLPFAMultisample,
        NSOpenGLPFASampleBuffers, static_cast<NSOpenGLPixelFormatAttribute>(samples ? 1 : 0),
        NSOpenGLPFASamples, static_cast<NSOpenGLPixelFormatAttribute>(samples),
        NSOpenGLPFAAccelerated,
        NSOpenGLPFADoubleBuffer,
        NSOpenGLPFAColorSize, 32,
        NSOpenGLPFADepthSize, 24,
        NSOpenGLPFAAlphaSize, 8,
        NSOpenGLPFAOpenGLProfile, NSOpenGLProfileVersion3_2Core,
        0
    };
    
    NSOpenGLPixelFormat* pf = [[NSOpenGLPixelFormat alloc] initWithAttributes:windowedAttrs];
    
    if (!pf) {
        bool valid = false;
        while (!pf && samples > 0) {
            samples /= 2;
            windowedAttrs[2] = samples ? 1 : 0;
            windowedAttrs[4] = samples;
            pf = [[NSOpenGLPixelFormat alloc] initWithAttributes:windowedAttrs];
            if (pf) {
                valid = true;
                break;
            }
        }
        
        if (!valid) {
            NSLog(@"OpenGL pixel format not supported.");
            return nil;
        }
    }
    
    self = [super initWithFrame:frame pixelFormat:[pf autorelease]];
    appLock = [[NSRecursiveLock alloc] init];
    
    return self;
}

- (void) prepareOpenGL {
    [super prepareOpenGL];
    
    [[self window] setLevel: NSNormalWindowLevel];
    [[self window] makeKeyAndOrderFront: self];
    
    [[self openGLContext] makeCurrentContext];

    GLint swapInt = 1;
    [[self openGLContext] setValues:&swapInt forParameter:NSOpenGLCPSwapInterval];
    
    CVDisplayLinkCreateWithActiveCGDisplays(&displayLink);
    
    CVDisplayLinkSetOutputCallback(displayLink, &GlobalDisplayLinkCallback, self);
    
    CGLContextObj cglContext = (CGLContextObj)[[self openGLContext] CGLContextObj];
    CGLPixelFormatObj cglPixelFormat = (CGLPixelFormatObj)[[self pixelFormat] CGLPixelFormatObj];
    CVDisplayLinkSetCurrentCGDisplayFromOpenGLContext(displayLink, cglContext, cglPixelFormat);
    
    GLint dim[2] = {static_cast<GLint>(windowRect.size.width), static_cast<GLint>(windowRect.size.height)};
    CGLSetParameter(cglContext, kCGLCPSurfaceBackingSize, dim);
    CGLEnable(cglContext, kCGLCESurfaceBackingSize);
    
    [appLock lock];
    CGLLockContext((CGLContextObj)[[self openGLContext] CGLContextObj]);
    NSLog(@"Initialize");
    
    NSLog(@"GL version:   %s", glGetString(GL_VERSION));
    NSLog(@"GLSL version: %s", glGetString(GL_SHADING_LANGUAGE_VERSION));
    OpenGLInit::instance()->setColor();
    OpenGLInit::instance()->setViewport(windowRect.size.width, windowRect.size.height);
    CGLUnlockContext((CGLContextObj)[[self openGLContext] CGLContextObj]);
    [appLock unlock];
    
    CVDisplayLinkStart(displayLink);
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (CVReturn) getFrameForTime:(const CVTimeStamp*)outputTime {
    [appLock lock];
    
    [[self openGLContext] makeCurrentContext];
    CGLLockContext((CGLContextObj)[[self openGLContext] CGLContextObj]);
    
    OpenGLInit::instance()->clear();
    
    CGLFlushDrawable((CGLContextObj)[[self openGLContext] CGLContextObj]);
    CGLUnlockContext((CGLContextObj)[[self openGLContext] CGLContextObj]);
    
    if (false) {
        [NSApp terminate:self];
    }
    
    [appLock unlock];
    
    return kCVReturnSuccess;
}

- (void)windowDidResize:(NSNotification*)notification {
    NSSize size = [ [ _window contentView ] frame ].size;
    [appLock lock];
    [[self openGLContext] makeCurrentContext];
    CGLLockContext((CGLContextObj)[[self openGLContext] CGLContextObj]);

    windowRect.size.width = size.width;
    windowRect.size.height = size.height;
    OpenGLInit::instance()->setViewportResize(windowRect.size.width, windowRect.size.height);

    CGLUnlockContext((CGLContextObj)[[self openGLContext] CGLContextObj]);
    [appLock unlock];
}

- (void)resumeDisplayRenderer  {
    [appLock lock];
    CVDisplayLinkStop(displayLink);
    [appLock unlock];
}

- (void)haltDisplayRenderer  {
    [appLock lock];
    CVDisplayLinkStop(displayLink);
    [appLock unlock];
}

-(void)windowWillClose:(NSNotification *)notification {
    if (running) {
        running = false;
        
        [appLock lock];
        NSLog(@"Cleanup");
        
        CVDisplayLinkStop(displayLink);
        CVDisplayLinkRelease(displayLink);
        
        [appLock unlock];
    }
    
    [NSApp terminate:self];
}

- (void) dealloc {
    [appLock release];
    [super dealloc];
}

+ (id)viewInstance {
    @synchronized(self) {
        if(sharedView == nil)
            sharedView = [[super allocWithZone:NULL] init];
    }
    return sharedView;
}



@end
static CVReturn GlobalDisplayLinkCallback(CVDisplayLinkRef displayLink, const CVTimeStamp* now, const CVTimeStamp* outputTime, CVOptionFlags flagsIn, CVOptionFlags* flagsOut, void* displayLinkContext) {
    CVReturn result = [(View*)displayLinkContext getFrameForTime:outputTime];
    return result;
}
