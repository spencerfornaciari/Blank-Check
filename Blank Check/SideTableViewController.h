//
//  SideTableViewController.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/24/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedBrowserTableViewController.h"
#import "DetailScrollViewController.h"

@interface SideTableViewController : UITableViewController <UIGestureRecognizerDelegate, FeedBrowserTableViewControllerDelegate, UIActionSheetDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITableViewCell *userCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *logoutCell;


@property (strong, nonatomic) IBOutlet UIBarButtonItem *menuButton;
//- (IBAction)menuButtonAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *searchButton;


@end
