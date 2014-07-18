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
#import "Gamer.h"
#import "LoadingView.h"
//#import "GAITrackedViewController.h"
//#import "GAIDictionaryBuilder.h"
//#import "GAIFields.h"

@protocol FeedBrowserTableViewControllerDelegate <NSObject>

-(void)openMenu;
-(void)closeMenu;

@end

@interface FeedBrowserTableViewController : UITableViewController <NetworkControllerDelegate>

@property (nonatomic, weak) id<FeedBrowserTableViewControllerDelegate> delegate;

- (IBAction)handleMenuButton:(id)sender;


@end