//
//  ExpertInsightView.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/2/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "ExpertInsightView.h"

@implementation ExpertInsightView

-(id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *expertLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 206, 21)];
        expertLabel.text = @"EXPERT INSIGHTS";
        expertLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0];
        [self addSubview:expertLabel];
        
        self.profileImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40, 100, 100)];
        self.profileImage.image = [UIImage imageNamed:@"default-user"];
        [self addSubview:self.profileImage];

        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(125, 40, 170, 20)];
        self.nameLabel.text = @"Johnny Appleseed";
        [self addSubview:self.nameLabel];
        
        self.positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(125, 70, 170, 20)];
        self.positionLabel.text = @"President, Apple Inc.";
        [self addSubview:self.positionLabel];
        
        self.locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(125, 100, 170, 20)];
        self.locationLabel.text = @"Cupertino, CA";
        [self addSubview:self.locationLabel];
        
        return self;
    }
    
    return nil;
}

@end
