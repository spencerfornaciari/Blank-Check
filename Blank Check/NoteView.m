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
        self.backgroundColor = [UIColor blankCheckLightBlue];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                            initWithKey:@"date" ascending:NO];
        
        
        self.noteArray = [[self.worker valueForKey:@"notes"] sortedArrayUsingDescriptors:@[sortDescriptor]];
        
        CGRect newRect = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height - 50);
        
        self.tableView = [[UITableView alloc] initWithFrame:newRect];
        self.tableView.backgroundColor = [UIColor blankCheckLightBlue];
        //        self.tableView.alpha = 0.9;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView setSeparatorColor:[UIColor blackColor]];
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        [self addSubview:self.tableView];
        
        self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.closeButton.frame = CGRectMake(50, self.bounds.size.height - 50, 100, 40);
        self.closeButton.center = CGPointMake(self.frame.size.width / 2, self.bounds.size.height - 25);
        [self.closeButton setTitle:@"Close" forState:UIControlStateNormal];
        [self.closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.closeButton.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.closeButton];
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
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mma"];
    NSString *dateString = [dateFormatter stringFromDate:note.date];
    
    cell.textLabel.text = note.comments;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@ - %@", connection.firstName, connection.lastName, dateString];
    
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
