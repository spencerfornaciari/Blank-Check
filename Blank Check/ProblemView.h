//
//  ProblemView.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/22/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProblemView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UIButton *closeButton;
@property (nonatomic) UITableView *tableView;

@property (nonatomic) NSArray *problemArray;

@end
