//
//  MainWindow.m
//  EmailProfileGenerator
//
//  Created by kuaijianghua on 6/26/14.
//  Copyright (c) 2014 RampageWorks. All rights reserved.
//

#import "MainWindow.h"
#include <string>
#include <iostream>
#include <fstream>

using namespace std;

@implementation MainWindow

void writeToFile(string fileString, string filePath){
    ofstream outputFile;
    outputFile.open(filePath, std::ofstream::out);
    
    outputFile << fileString;
    
    outputFile.close();
}

- (void)setupTheWindow
{
    [self.clientNameTextFiled becomeFirstResponder];
}

- (IBAction)generateProfile:(id)sender
{
    if ((!self.clientNameTextFiled.stringValue || [self.clientNameTextFiled.stringValue isEqualToString:@""]) ||
        (!self.emailTextFiled.stringValue || [self.emailTextFiled.stringValue isEqualToString:@""]) ||
        (!self.passwordextFiled.stringValue || [self.passwordextFiled.stringValue isEqualToString:@""])) {
        [self showErrorMessage:@"Hey dude you forget to input some information." withTitle:@"Error"];
        return;
    }
    
    if (![self isEmail:self.emailTextFiled.stringValue]) {
        [self showErrorMessage:@"You're so dull! You can't even make the Email address right!." withTitle:@"Error"];
        return;
    }
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"EmailConfiguration"
                                                         ofType:@"mobileconfig"];
    
    //Open the configuration file
    NSError *error = nil;
    NSString *configureFile = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    
    if (error) {
        [self showErrorMessage:@"Failed to open the configure file, please contact Jiang to fix this." withTitle:@"Error"];
        return;
    }
    
    NSXMLDocument* xmlDoc = [[NSXMLDocument alloc] initWithXMLString:configureFile options:(NSXMLNodePreserveWhitespace | NSXMLNodePreserveCDATA) error:&error];
    if (error) {
        [self showErrorMessage:@"Failed to parase the configure file, please contact Jiang to fix this." withTitle:@"Error"];
        return;
    }
    
    NSXMLElement* root  = [xmlDoc rootElement];
    root = [[root elementsForName:@"dict"] firstObject];
    root = [[root elementsForName:@"array"] firstObject];
    root = [[root elementsForName:@"dict"] firstObject];
    
    
    //Add the user information into the file
    //Set up the name
    NSXMLElement *userNameTitleNode = [[NSXMLElement alloc] initWithName:@"key" stringValue:@"EmailAccountName"];
    [root addChild:userNameTitleNode];
    
    NSXMLElement *userNameStringNode = [[NSXMLElement alloc] initWithName:@"string" stringValue:self.clientNameTextFiled.stringValue];
    [root addChild:userNameStringNode];
    
    //Set up the Email address
    NSXMLElement *emailTitleNode = [[NSXMLElement alloc] initWithName:@"key" stringValue:@"EmailAddress"];
    NSXMLElement *emailStringNode = [[NSXMLElement alloc] initWithName:@"string" stringValue:self.emailTextFiled.stringValue];
    [root addChild:emailTitleNode];
    [root addChild:emailStringNode];
    
    NSXMLElement *emailInTitleNode = [[NSXMLElement alloc] initWithName:@"key" stringValue:@"IncomingMailServerUsername"];
    NSXMLElement *emailInStringNode = [[NSXMLElement alloc] initWithName:@"string" stringValue:self.emailTextFiled.stringValue];
    [root addChild:emailInTitleNode];
    [root addChild:emailInStringNode];

    NSXMLElement *emailOutTitleNode = [[NSXMLElement alloc] initWithName:@"key" stringValue:@"OutgoingMailServerUsername"];
    NSXMLElement *emailOutStringNode = [[NSXMLElement alloc] initWithName:@"string" stringValue:self.emailTextFiled.stringValue];
    [root addChild:emailOutTitleNode];
    [root addChild:emailOutStringNode];

    //Set up the email password
    NSXMLElement *passwordInTitleNode = [[NSXMLElement alloc] initWithName:@"key" stringValue:@"IncomingPassword"];
    NSXMLElement *passwordInStringNode = [[NSXMLElement alloc] initWithName:@"string" stringValue:self.passwordextFiled.stringValue];
    [root addChild:passwordInTitleNode];
    [root addChild:passwordInStringNode];
    
    NSXMLElement *passwordOutTitleNode = [[NSXMLElement alloc] initWithName:@"key" stringValue:@"OutgoingPassword"];
    NSXMLElement *passwordOutStringNode = [[NSXMLElement alloc] initWithName:@"string" stringValue:self.passwordextFiled.stringValue];
    [root addChild:passwordOutTitleNode];
    [root addChild:passwordOutStringNode];
    
    //Export the file
    NSData* xmlData = [xmlDoc XMLDataWithOptions:NSXMLNodePrettyPrint];
    NSArray * paths = NSSearchPathForDirectoriesInDomains (NSDesktopDirectory, NSUserDomainMask, YES);
    NSString * desktopPath = [paths objectAtIndex:0];
    NSString *desktopURL = [NSString stringWithFormat:@"%@/%@.mobileconfig",desktopPath,self.clientNameTextFiled.stringValue];
    
    NSString* fileString = [[NSString alloc] initWithData:xmlData
                                             encoding:NSUTF8StringEncoding];
    writeToFile([fileString UTF8String], [desktopURL UTF8String]);
    
    if (self.mainWindowDelegate && [self.mainWindowDelegate respondsToSelector:@selector(successfulGenerated)]) {
        [self.mainWindowDelegate successfulGenerated];
    }
}

- (BOOL)isEmail:(NSString*)string
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:string];
}

- (void)showErrorMessage:(NSString*)message withTitle:(NSString*)title
{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"OK"];
    [alert setMessageText:title];
    [alert setInformativeText:message];
    [alert setAlertStyle:NSWarningAlertStyle];
    [alert runModal];
}


@end
