//
//  ExpertAppraisalView.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/2/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "ExpertAppraisalView.h"

@implementation ExpertAppraisalView

-(id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        self.backgroundColor = [UIColor greenColor];
        
//        self.profileImage.frame = CGRectMake(10, 10, 40, 40);
//        self.profileImage.backgroundColor = [UIColor purpleColor];
//        [self addSubview:self.profileImage];
//        
//        self.nameLabel.frame = CGRectMake(100, 200, 100, 20);
//        self.nameLabel.text = @"EXPERT APPRAISAL";
//        [self addSubview:self.nameLabel];
        
        return self;
    }
    
    return nil;
}

@end
