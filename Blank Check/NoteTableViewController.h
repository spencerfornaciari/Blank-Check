//
//  NoteTableViewController.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 8/13/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Worker.h"
#import "Connection.h"
#import "Note.h"

@interface NoteTableViewController : UITableViewController <UIActionSheetDelegate>

@property (nonatomic) NSArray *noteArray;
@property (nonatomic) Worker *worker;

@end
