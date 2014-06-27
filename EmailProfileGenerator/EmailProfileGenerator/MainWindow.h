//
//  MainWindow.h
//  EmailProfileGenerator
//
//  Created by kuaijianghua on 6/26/14.
//  Copyright (c) 2014 RampageWorks. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol MainWindowDelegate <NSObject>

- (void)successfulGenerated;

@end

@interface MainWindow : NSWindow

@property (nonatomic, weak) IBOutlet NSTextField *clientNameTextFiled;
@property (nonatomic, weak) IBOutlet NSTextField *emailTextFiled;
@property (nonatomic, weak) IBOutlet NSTextField *passwordextFiled;
@property (nonatomic, weak) id<MainWindowDelegate> mainWindowDelegate;

- (IBAction)generateProfile:(id)sender;
- (void)setupTheWindow;

@end
