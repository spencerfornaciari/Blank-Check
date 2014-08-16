//
//  PresetViewController.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 6/9/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "PresetViewController.h"
#import "UIColor+BlankCheckColors.h"

@interface PresetViewController ()

@end

@implementation PresetViewController

- (void)viewDidLoad
{
    
    if ([self.category isEqualToString:@"Person"]) {
        UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 75, 280, 40)];
        newLabel.text = self.pageTitle;
        newLabel.font =[UIFont fontWithName:@"Avenir" size:33.0];
        newLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:newLabel];
        
        UILabel *yourValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 160, 160, 20)];
        yourValueLabel.text = @"Current Value";
        yourValueLabel.textAlignment = NSTextAlignmentRight;
        [self.view addSubview:yourValueLabel];
        
        UILabel *currentValue = [[UILabel alloc] initWithFrame:CGRectMake(180, 180, 100, 20)];
        currentValue.text = @"$800,000";
        currentValue.textAlignment = NSTextAlignmentRight;
        //    [currentValue sizeToFit];
        [self.view addSubview:currentValue];
        
        UILabel *currentValueChange = [[UILabel alloc] initWithFrame:CGRectMake(200, 200, 80, 20)];
        currentValueChange.text = [NSString stringWithFormat:@"-$20,000"];
        currentValueChange.numberOfLines = 1;
        currentValueChange.textColor = [UIColor whiteColor];
        currentValueChange.backgroundColor = [UIColor redColor];
        currentValueChange.textAlignment = NSTextAlignmentRight;
        [self.view addSubview:currentValueChange];
        
        //Add profile picture
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 120, 120, 120)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.layer.cornerRadius = 60.f;
        imageView.layer.masksToBounds = TRUE;
        imageView.backgroundColor = [UIColor blankCheckBlue];
        [self.view addSubview:imageView];
        
        UIImageView *graph = [[UIImageView alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height-(self.view.frame.size.width-20), self.view.frame.size.width-40, self.view.frame.size.width-40)];
        graph.backgroundColor = [UIColor blankCheckBlue];
        [self.view addSubview:graph];
    }
    


    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.screenName = [NSString stringWithFormat:@"%@", self.pageTitle];
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
