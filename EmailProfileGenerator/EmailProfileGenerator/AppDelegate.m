//
//  AppDelegate.m
//  EmailProfileGenerator
//
//  Created by kuaijianghua on 6/26/14.
//  Copyright (c) 2014 RampageWorks. All rights reserved.
//

#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    self.window.mainWindowDelegate = self;
    
    [self.successWindow setStyleMask:NSBorderlessWindowMask];
    self.successWindow.backgroundColor = [NSColor clearColor];
    [self.successWindow setOpaque:NO];
    self.successWindow.alphaValue = 0;
    [self.successWindow orderOut:self];
    
    [self.window makeKeyAndOrderFront:nil];
    [self.window setupTheWindow];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag
{
    if ( flag ) {
        [self.window orderFront:self];
    }
    else {
        [self.window makeKeyAndOrderFront:self];
    }
    
    [self.window setupTheWindow];
    
    return YES;
}

- (void)successfulGenerated
{
    [self.successWindow makeKeyAndOrderFront:self];
    [NSApp activateIgnoringOtherApps:YES];
    
    [NSAnimationContext beginGrouping]; {
        [[NSAnimationContext currentContext] setDuration:0.5];
        [[NSAnimationContext currentContext] setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [self.successWindow.animator setAlphaValue:1.0];
    } [NSAnimationContext endGrouping];
    
    [self performSelector:@selector(dismissTheSuccessWindow) withObject:nil afterDelay:1.0];
}

- (void)dismissTheSuccessWindow
{
    [NSAnimationContext beginGrouping]; {
        [[NSAnimationContext currentContext] setDuration:0.5];
        [[NSAnimationContext currentContext] setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [self.successWindow.animator setAlphaValue:0.0];
    } [NSAnimationContext endGrouping];
}

@end
