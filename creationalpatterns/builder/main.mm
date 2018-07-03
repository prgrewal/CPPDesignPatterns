#import <Cocoa/Cocoa.h>
#import <OpenGL/OpenGL.h>
#import <OpenGL/gl3.h>
#import <iostream>
#import "Director.hpp"
#import "OrangeTriangleBuilder.cpp"
#import "YellowTriangleBuilder.cpp"
@class View;

@interface View : NSOpenGLView <NSWindowDelegate> {
@public
    CVDisplayLinkRef displayLink;
    bool running;
    NSRect windowRect;
    NSRecursiveLock* appLock;
    OrangeTriangleBuilder* orangeTriangleBuilder;
    YellowTriangleBuilder* yellowTriangleBuilder;
}
@end

@implementation View
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
    [appLock lock];
    NSLog(@"Initialize");
    
    NSLog(@"GL version:   %s", glGetString(GL_VERSION));
    NSLog(@"GLSL version: %s", glGetString(GL_SHADING_LANGUAGE_VERSION));
    
    glViewport(0, 0, windowRect.size.width, windowRect.size.height);
    
    Director* director;
    orangeTriangleBuilder = new OrangeTriangleBuilder();
    yellowTriangleBuilder = new YellowTriangleBuilder();
    director = new Director();
    director->CreateTriangle(orangeTriangleBuilder);
    director->CreateTriangle(yellowTriangleBuilder);
    delete director;

    [appLock unlock];
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (void)windowDidResize:(NSNotification*)notification {
    NSSize size = [ [ _window contentView ] frame ].size;
    [appLock lock];
    [[self openGLContext] makeCurrentContext];
    NSLog(@"Window resize: %lf, %lf", size.width, size.height);
    windowRect.size.width = size.width;
    windowRect.size.height = size.height;
    glViewport(0, 0, windowRect.size.width, windowRect.size.height);
    [appLock unlock];
}

-(void)windowWillClose:(NSNotification *)notification {
   
    [NSApp terminate:self];
}

- (void) dealloc {
    [appLock release];
    [super dealloc];
}

- (void)lockFocus
{
    NSOpenGLContext* context = [self openGLContext];
    
    [super lockFocus];
    if ([context view] != self) {
        [context setView:self];
    }
    [context makeCurrentContext];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    [[self openGLContext] makeCurrentContext];
    
    glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    orangeTriangleBuilder->getTriangle();
    yellowTriangleBuilder->getTriangle();
  
    [[self openGLContext] flushBuffer];
    
}
@end

int main(int argc, const char * argv[])  {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    [NSApplication sharedApplication];
    
    NSUInteger windowStyle = NSWindowStyleMaskTitled  | NSWindowStyleMaskClosable | NSWindowStyleMaskResizable | NSWindowStyleMaskMiniaturizable;
    
    NSRect screenRect = [[NSScreen mainScreen] frame];
    NSRect viewRect = NSMakeRect(0, 0, 800, 600);
    NSRect windowRect = NSMakeRect(NSMidX(screenRect) - NSMidX(viewRect),
                                   NSMidY(screenRect) - NSMidY(viewRect),
                                   viewRect.size.width,
                                   viewRect.size.height);
    
    NSWindow * window = [[NSWindow alloc] initWithContentRect:windowRect
                                                    styleMask:windowStyle
                                                      backing:NSBackingStoreBuffered
                                                        defer:NO];
    [window autorelease];
    
    NSWindowController * windowController = [[NSWindowController alloc] initWithWindow:window];
    [windowController autorelease];
    
    [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
    
    id menubar = [[NSMenu new] autorelease];
    id appMenuItem = [[NSMenuItem new] autorelease];
    [menubar addItem:appMenuItem];
    [NSApp setMainMenu:menubar];
    
    id appMenu = [[NSMenu new] autorelease];
    id appName = [[NSProcessInfo processInfo] processName];
    id quitTitle = [@"Quit " stringByAppendingString:appName];
    id quitMenuItem = [[[NSMenuItem alloc] initWithTitle:quitTitle
                                                  action:@selector(terminate:) keyEquivalent:@"q"] autorelease];
    [appMenu addItem:quitMenuItem];
    [appMenuItem setSubmenu:appMenu];
    
    View* view = [[[View alloc] initWithFrame:windowRect] autorelease];
    view->windowRect = windowRect;
    [window setAcceptsMouseMovedEvents:YES];
    [window setContentView:view];
    [window setDelegate:view];
    
    delete view->orangeTriangleBuilder;
    delete view->yellowTriangleBuilder;
    
    [window setTitle:appName];
    
    [window setCollectionBehavior: NSWindowCollectionBehaviorFullScreenPrimary];
    
    [window orderFrontRegardless];
    [NSApp run];
    
    [pool drain];
    
    return (0);
}

