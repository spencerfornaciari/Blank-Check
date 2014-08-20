//
//  BlankCheckViewCell.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 6/11/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import "SocialController.h"
#import "UIColor+BlankCheckColors.h"

@interface BlankCheckViewCell : UICollectionViewCell <UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UIImageView *graphImage;

@property (nonatomic) UIButton *socialButton;

@end
