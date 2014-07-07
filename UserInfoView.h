//
//  UserInfoView.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/2/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoView : UIView

@property (nonatomic) UILabel *workExperienceLabel;
@property (nonatomic) UILabel *educationLabel;

@property (nonatomic) UIButton *linkedinButton;

-(id)initWithFrame:(CGRect)frame;

@end
