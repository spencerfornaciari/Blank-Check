//
//  NoteView.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/27/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataHelper.h"
#import "Worker.h"
#import "Note.h"
#import "Connection.h"

@interface NoteView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UIButton *closeButton;
@property (nonatomic) UITableView *tableView;

@property (nonatomic) NSArray *noteArray;
@property (nonatomic) Worker *worker;

@end
