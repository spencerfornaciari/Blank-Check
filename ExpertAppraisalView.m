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
        
        self.profileImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 80, 80)];
        self.profileImage.image = appraiser.profileImage;
        [self addSubview:self.profileImage];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 85, 80, 20)];
        self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", appraiser.firstName, [appraiser.lastName substringWithRange:NSMakeRange(0, 1)]];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
        [self addSubview:self.nameLabel];
        
        self.positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 90, 20)];
        self.positionLabel.text = appraiser.position;
        self.positionLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
        [self addSubview:self.positionLabel];
        
        self.companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 30, 90, 20)];
        self.companyLabel.text = appraiser.company;
        self.companyLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
        self.companyLabel.textColor = [UIColor blackColor];
        [self addSubview:self.companyLabel];
        
        self.locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 90, 20)];
        self.locationLabel.text = appraiser.location;
        self.locationLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
        [self addSubview:self.locationLabel];
        
        self.getEstimateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.getEstimateButton.frame = CGRectMake(210, 20, 100, 40);
        [self.getEstimateButton setTitle:@"Get Estimate" forState:UIControlStateNormal];
        [self.getEstimateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.getEstimateButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
        self.getEstimateButton.layer.borderWidth = 1.0;
        self.getEstimateButton.layer.borderColor = [UIColor blackColor].CGColor;
        [self.getEstimateButton addTarget:self action:@selector(GetEstimate) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.getEstimateButton];


        
        return self;
    }
    
    return nil;
}

@end
