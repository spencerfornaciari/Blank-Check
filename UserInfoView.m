//
//  UserInfoView.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/2/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "UserInfoView.h"

@implementation UserInfoView

-(id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;

        UILabel *userInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 128, 21)];
        userInfoLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0];
        userInfoLabel.text = @"USER INFO";
        [self addSubview:userInfoLabel];
        
        self.workExperienceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, userInfoLabel.frame.origin.y + 29, 300, 21)];
        self.workExperienceLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17.0];
        self.workExperienceLabel.text = [NSString stringWithFormat:@"Work Exp: Top 10%%"];
        [self addSubview:self.workExperienceLabel];
        
        self.educationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.workExperienceLabel.frame.origin.y + 29, 300, 21)];
        self.educationLabel.text = [NSString stringWithFormat:@"Education Exp: Top 5%%"];
        self.educationLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17.0];
        [self addSubview:self.educationLabel];
        
        self.linkedinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect linkedRect = CGRectMake(40, self.bounds.origin.y + self.frame.size.height - 70, 240, 50);
        self.linkedinButton.frame = linkedRect;
        [self.linkedinButton addTarget:self action:@selector(LinkedInAction) forControlEvents:UIControlEventTouchUpInside];
        [self.linkedinButton setTitle:@"See LinkedIn Summary" forState:UIControlStateNormal];
        self.linkedinButton.layer.borderWidth = 1.0;
        self.linkedinButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0];
        [self.linkedinButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.linkedinButton.layer.borderColor = [UIColor blackColor].CGColor;
        [self addSubview:self.linkedinButton];
 
        return self;
    }
    
    return nil;
}

-(void)LinkedInAction {
    NSLog(@"LINKEDIN");
}

@end
