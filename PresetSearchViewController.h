//
//  SearchViewController.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 6/3/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkController.h"

@interface PresetSearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UITableView *presetTableView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *searchSegmentController;

@property (nonatomic) NSArray *peopleArray, *titleArray, *locationArray, *listArray, *predicateArray;

@property (nonatomic) NSArray *searchArray;

-(IBAction)changeSegment:(id)sender;


@end
