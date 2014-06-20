//
//  DetailViewController.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 6/18/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "DetailViewController.h"
#import "UIColor+BlankCheckColors.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Blank Check Labs";
//    NSLog(@"Name: %@\n File Location: %@", self.gamer.fullName, self.gamer.profileImage);
    self.profileImage.image = self.gamer.profileImage;
    self.profileImage.layer.cornerRadius = 60.f;
    self.profileImage.layer.masksToBounds = TRUE;
    
    NSString *firstLetter = [self.gamer.lastName substringWithRange:NSMakeRange(0, 1)];
    
    self.userNameLabel.text = [NSString stringWithFormat:@"%@ %@.", self.gamer.firstName, firstLetter];
    
    self.valueLabel.text = [NSString stringWithFormat:@"$%@", [self.gamer.valueArray lastObject]];
    
    UIImageView *graph = [[UIImageView alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height-(self.view.frame.size.width-20), self.view.frame.size.width-40, self.view.frame.size.width-40)];
    graph.backgroundColor = [UIColor blankCheckBlue];
    [self.view addSubview:graph];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
