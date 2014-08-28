//
//  FeedBrowserTableViewController.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 6/18/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailScrollViewController.h"
#import "SearchViewController.h"
#import "AppDelegate.h"
#import "FeedTableViewCell.h"
#import "NetworkController.h"
#import "LoadingView.h"
#import "Worker.h"
#import "Job.h"
#import "LanguageProcessingController.h"


@protocol FeedBrowserTableViewControllerDelegate <NSObject>

-(void)openMenu;
-(void)closeMenu;
-(void)updateUser;

@end

@interface FeedBrowserTableViewController : UITableViewController <NetworkControllerDelegate>

@property (nonatomic, weak) id<FeedBrowserTableViewControllerDelegate> delegate;
//-(void)loadData;

- (IBAction)handleMenuButton:(id)sender;


@end