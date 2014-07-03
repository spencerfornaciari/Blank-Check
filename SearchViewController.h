//
//  SViewController.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/3/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> 
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSArray *searchArray;

@end
