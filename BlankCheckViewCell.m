//
//  BlankCheckViewCell.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 6/11/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "BlankCheckViewCell.h"

@implementation BlankCheckViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setCell:(Gamer *)gamer
{
//    self.nameLabel.text = gamer.fullName;
//    self.profileImage.backgroundColor = [UIColor greenColor];
//    self.graphImage.backgroundColor = [UIColor redColor];
    
    UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 320, 40)];
    newLabel.text = [NSString stringWithFormat:@"%@", gamer.fullName];
    newLabel.font =[UIFont fontWithName:@"HelveticaNeue" size:33.0];
    newLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:newLabel];
    
    UILabel *yourValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 120, 80, 20)];
    yourValueLabel.text = @"Your value";
    yourValueLabel.textAlignment = NSTextAlignmentRight;
    //    [yourValueLabel sizeToFit];
    [self addSubview:yourValueLabel];
    
    UILabel *currentValue = [[UILabel alloc] initWithFrame:CGRectMake(180, 140, 100, 20)];
    currentValue.text = @"$1,000,000";
    currentValue.textAlignment = NSTextAlignmentRight;
    //    [currentValue sizeToFit];
    [self addSubview:currentValue];

    
    UILabel *currentValueChange = [[UILabel alloc] initWithFrame:CGRectMake(200, 160, 80, 20)];
    currentValueChange.text = [NSString stringWithFormat:@"+$50,000"];
    currentValueChange.numberOfLines = 1;
    currentValueChange.textColor = [UIColor whiteColor];
    currentValueChange.backgroundColor = [UIColor redColor];
    currentValueChange.textAlignment = NSTextAlignmentRight;
    [self addSubview:currentValueChange];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 60, 120, 120)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.layer.cornerRadius = 60.f;
    imageView.layer.masksToBounds = TRUE;
    
    imageView.backgroundColor = [UIColor blankCheckBrown];
    [self addSubview:imageView];
    
    //Block off space for graph
    UIImageView *graph = [[UIImageView alloc] initWithFrame:CGRectMake(20, self.frame.size.height-(self.frame.size.width-60), self.frame.size.width-40, self.frame.size.width-40)];
    graph.backgroundColor = [UIColor blankCheckBlue];
    [self addSubview:graph];
    
    UIButton *socialButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [socialButton setFrame:CGRectMake(260, 100, 20, 20)];
    [self addSubview:socialButton];
    [socialButton setBackgroundImage:[UIImage imageNamed:@"Social-Share"] forState:UIControlStateNormal];
    [socialButton addTarget:self action:@selector(buttonPress) forControlEvents:UIControlEventTouchDown];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)buttonPress {
    NSLog(@"Button Press");
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Share this profile"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil otherButtonTitles:@"LinkedIn", @"Twitter", @"Facebook", nil];
    
    [actionSheet showInView:self];
}

@end
