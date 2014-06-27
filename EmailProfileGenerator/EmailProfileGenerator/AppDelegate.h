//
//  AppDelegate.h
//  EmailProfileGenerator
//
//  Created by kuaijianghua on 6/26/14.
//  Copyright (c) 2014 RampageWorks. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MainWindow.h"

@interface AppDelegate : NSObject <NSApplicationDelegate,MainWindowDelegate>

@property (assign) IBOutlet MainWindow *window;
@property (nonatomic, weak) IBOutlet NSWindow *successWindow;
@property (nonatomic, weak) IBOutlet NSImageView *successImageView;

@end
