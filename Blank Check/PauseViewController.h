//
//  PauseViewController.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/31/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkController.h"

@interface PauseViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *pauseButton;
- (IBAction)pauseAction:(id)sender;


@end
