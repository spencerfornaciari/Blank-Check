//
//  SViewController.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/3/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Connection.h"
//#import "GAITrackedViewController.h"

@interface SearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSArray *connectionsArray;

@end
