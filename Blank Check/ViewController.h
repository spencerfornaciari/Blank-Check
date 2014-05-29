//
//  ViewController.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 5/15/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "NetworkController.h"

@interface ViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic) AppDelegate *appDelegate;
@property (nonatomic) NetworkController *controller;

@end
