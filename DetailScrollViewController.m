//
//  DetailScrollViewController.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 6/23/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "DetailScrollViewController.h"
#import "UIColor+BlankCheckColors.h"

@interface DetailScrollViewController ()

@end

@implementation DetailScrollViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Blank Check Labs";
    
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(320, 1000)];
    
    
    //    NSLog(@"Name: %@\n File Location: %@", self.gamer.fullName, self.gamer.profileImage);
    profileImage.image = self.gamer.profileImage;
    profileImage.layer.cornerRadius = 60.f;
    profileImage.layer.masksToBounds = TRUE;
    
    NSString *firstLetter = [self.gamer.lastName substringWithRange:NSMakeRange(0, 1)];
    
    userNameLabel.text = [NSString stringWithFormat:@"%@ %@.", self.gamer.firstName, firstLetter];
    
    valueLabel.text = [NSString stringWithFormat:@"$%@", [self.gamer.valueArray lastObject]];
    
    UIImageView *graph = [[UIImageView alloc] initWithFrame:CGRectMake(20, 210, self.view.frame.size.width-40, self.view.frame.size.width-40)];
    graph.backgroundColor = [UIColor blankCheckBlue];
    [scrollView addSubview:graph];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    NSLog(@"Look ma, I'm scrolling");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
