//
//  NoteViewController.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/31/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteViewController : UIViewController

@property (nonatomic, weak) UIButton *closeButton;
@property (nonatomic) UITableView *tableView;

@property (nonatomic) NSArray *noteArray;

@end
