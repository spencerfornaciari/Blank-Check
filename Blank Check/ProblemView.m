//
//  ProblemView.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/22/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "ProblemView.h"

@implementation ProblemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor greenColor];
    
        UILabel *problemLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.frame.size.width, 30)];
        problemLabel.textAlignment = NSTextAlignmentCenter;
        problemLabel.text = @"Report a Problem";
        problemLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0];
        problemLabel.textColor = [UIColor whiteColor];
        problemLabel.alpha = 1;
        [self addSubview:problemLabel];
        
        
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        closeButton.frame = CGRectMake(50, self.bounds.size.height - 50, 100, 40);
        closeButton.center = CGPointMake(self.frame.size.width / 2, self.bounds.size.height - 50);
        [closeButton setTitle:@"Close" forState:UIControlStateNormal];
//        [closeButton addTarget:self action:@selector(inviteTarget:) forControlEvents:UIControlEventTouchUpInside];
        [closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        closeButton.backgroundColor = [UIColor whiteColor];
        [self addSubview:closeButton];

        
        
    }
    return self;
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
