#include <iostream>
#include "openGl.h"
#include "view.mm"

using namespace std;
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
    
    View* viewInstance = [[[View viewInstance] initWithFrame:windowRect] autorelease];
    viewInstance->windowRect = windowRect;
    [window setAcceptsMouseMovedEvents:YES];
    [window setContentView:viewInstance];
    [window setDelegate:viewInstance];

    [window setTitle:appName];
    
    [window setCollectionBehavior: NSWindowCollectionBehaviorFullScreenPrimary];
    
    [window orderFrontRegardless];
    [NSApp run];
    
    [pool drain];
    
    return (0);
}
