#ifndef view_h
#define view_h
#import <Cocoa/Cocoa.h>
#import <QuartzCore/CVDisplayLink.h>
#import <foundation/Foundation.h>
@class View;
static CVReturn GlobalDisplayLinkCallback(CVDisplayLinkRef, const CVTimeStamp*, const CVTimeStamp*, CVOptionFlags, CVOptionFlags*, void*);
@interface View : NSOpenGLView <NSWindowDelegate> {
@public
    CVDisplayLinkRef displayLink;
    bool running;
    NSRect windowRect;
    NSRecursiveLock* appLock;
}

+ (id) viewInstance;

@end

#endif /* view_h */
