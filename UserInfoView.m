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

        UILabel *userInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 128, 21)];
        userInfoLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0];
        userInfoLabel.text = @"USER INFO";
        [self addSubview:userInfoLabel];
        
        self.workExperienceLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, userInfoLabel.frame.origin.y + 29, 300, 21)];
        self.workExperienceLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17.0];
        self.workExperienceLabel.text = [NSString stringWithFormat:@"Work Exp: Top 10%%"];
        [self addSubview:self.workExperienceLabel];
        
        self.educationLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.workExperienceLabel.frame.origin.y + 29, 300, 21)];
        self.educationLabel.text = [NSString stringWithFormat:@"Education Exp: Top 5%%"];
        self.educationLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17.0];
        [self addSubview:self.educationLabel];
        
        //        self.profileImage.frame = CGRectMake(10, 10, 40, 40);
//        self.profileImage.backgroundColor = [UIColor purpleColor];
//        [self addSubview:self.profileImage];
//        
//        self.nameLabel.frame = CGRectMake(100, 200, 100, 20);
//        self.nameLabel.text = @"USER INFO";
//        [self addSubview:self.nameLabel];
//        
        return self;
    }
    
    return nil;
}

@end
