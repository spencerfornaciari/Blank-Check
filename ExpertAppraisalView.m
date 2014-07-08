//
//  ExpertAppraisalView.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/2/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "ExpertAppraisalView.h"

@implementation ExpertAppraisalView

-(id)initWithFrame:(CGRect)frame andExpertAppraiser:(ExpertAppraisal *)appraiser {
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        self.backgroundColor = [UIColor greenColor];
        
        self.profileImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 100, 100)];
        self.profileImage.image = appraiser.profileImage;
        [self addSubview:self.profileImage];
        
        NSString *nameString = [appraiser.lastName substringWithRange:NSMakeRange(0, 1)];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 105, 100, 20)];
        self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", appraiser.firstName, nameString];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
        [self addSubview:self.nameLabel];
        
//        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, 100, 20)];
//        self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", appraiser.firstName, appraiser.lastName];
//        self.nameLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
//        [self addSubview:self.nameLabel];
        
//        
//        self.nameLabel.frame = CGRectMake(100, 200, 100, 20);
//        self.nameLabel.text = @"EXPERT APPRAISAL";
//        [self addSubview:self.nameLabel];
        
        return self;
    }
    
    return nil;
}

@end
