//
//  ExpertInsightView.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/2/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Insight.h"

@interface ExpertInsightView : UIView

@property (nonatomic) UIImageView *profileImage;
@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UILabel *positionLabel;
@property (nonatomic) UILabel *companyLabel;
@property (nonatomic) UILabel *locationLabel;
@property (nonatomic) UILabel *commentLabel;

-(id)initWithFrame:(CGRect)frame andExpertInsight:(Insight *)insight;

@end