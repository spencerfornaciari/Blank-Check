//
//  ExpertInsightView.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/2/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "ExpertInsightView.h"

@implementation ExpertInsightView

-(id)initWithFrame:(CGRect)frame andExpertInsight:(Insight *)insight {
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        
        self.profileImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 100, 100)];
        self.profileImage.image = [UIImage imageNamed:@"default-user"];
        [self addSubview:self.profileImage];

        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 105, 100, 20)];
        self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", insight.firstName, [insight.lastName substringWithRange:NSMakeRange(0, 1)]];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.nameLabel];
        
        self.positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(125, 10, 170, 20)];
        self.positionLabel.text = insight.position;
        [self addSubview:self.positionLabel];
        
        self.companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(125, 35, 170, 20)];
        self.companyLabel.text = insight.company;
        [self addSubview:self.companyLabel];
        
        self.locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(125, 60, 170, 20)];
        self.locationLabel.text = insight.location;
        [self addSubview:self.locationLabel];
        
        self.commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 140, 300, 60)];
        self.commentLabel.text = insight.comments;
        self.commentLabel.numberOfLines = 0;
        [self.commentLabel sizeToFit];
        [self addSubview:self.commentLabel];
        
        return self;
    }
    
    return nil;
}

@end
