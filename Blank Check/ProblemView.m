//
//  ProblemView.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/22/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "ProblemView.h"
#import "UIColor+BlankCheckColors.h"

@implementation ProblemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.problemArray = [NSArray arrayWithObjects:@"General Feedback", @"Flag an Inaccurate Listing", @"Something is Not Working", nil];
        
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds];
        self.tableView.backgroundColor = [UIColor blankCheckBlue];
        self.tableView.alpha = 0.9;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView setSeparatorColor:[UIColor blackColor]];
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        [self addSubview:self.tableView];

        
        self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.closeButton.frame = CGRectMake(50, self.bounds.size.height - 50, 100, 40);
        self.closeButton.center = CGPointMake(self.frame.size.width / 2, self.bounds.size.height - 50);
        [self.closeButton setTitle:@"Close" forState:UIControlStateNormal];
        [self.closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.closeButton.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.closeButton];

        
        
    }
    return self;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    
    CGRect sepFrame = CGRectMake(0, headerView.frame.size.height-1, self.frame.size.width, 1);
    UIView *seperatorView = [[UIView alloc] initWithFrame:sepFrame];
    seperatorView.backgroundColor = [UIColor colorWithWhite:144.0/255.0 alpha:1.0];
    [headerView addSubview:seperatorView];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    lbl.text = @"Report a Problem";
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0];
    lbl.textColor = [UIColor whiteColor];
    [headerView addSubview:lbl];
    
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.problemArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    
    cell.textLabel.text = self.problemArray[indexPath.row];
    cell.backgroundColor = [UIColor blankCheckBlue];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        NSLog(@"General Feedback");
    } else if (indexPath.row == 1) {
        NSLog(@"Flag an Inaccurate Listing");
    } else {
        NSLog(@"Something is Not Working");
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
