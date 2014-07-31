//
//  NoteView.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/27/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "NoteView.h"
#import "UIColor+BlankCheckColors.h"

@implementation NoteView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.worker = [CoreDataHelper currentUser];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                            initWithKey:@"date" ascending:YES];
        
        
        self.noteArray = [[self.worker valueForKey:@"notes"] sortedArrayUsingDescriptors:@[sortDescriptor]];
        
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds];
        self.tableView.backgroundColor = [UIColor blankCheckLightBlue];
        //        self.tableView.alpha = 0.9;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView setSeparatorColor:[UIColor blackColor]];
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        [self addSubview:self.tableView];
        
    }
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.noteArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    
    Note *note = self.noteArray[indexPath.row];
    
    Connection *connection = note.connection;
    
    cell.textLabel.text = note.comments;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", connection.firstName, connection.lastName];
    
    return cell;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    return TRUE;
}

@end
