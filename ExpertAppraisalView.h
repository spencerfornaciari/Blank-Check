//
//  ExpertAppraisalView.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/2/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpertAppraisal.h"

@interface ExpertAppraisalView : UIView

@property (nonatomic) UILabel *nameLabel;

@property (nonatomic) UILabel *positionLabel;
@property (nonatomic) UILabel *companyLabel;
@property (nonatomic) UILabel *locationLabel;

@property (nonatomic) UIImageView *profileImage;

@property (nonatomic) UIButton *getEstimateButton;

-(id)initWithFrame:(CGRect)frame andExpertAppraiser:(ExpertAppraisal *)appraiser;

@end
