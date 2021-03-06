//
//  TimelineView.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/2/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimelineEvent.h"

@interface TimelineView : UIView

@property (nonatomic) UIImageView *profileImage;
@property (nonatomic) UILabel *nameLabel;

-(id)initWithFrame:(CGRect)frame andTimelineEvent:(TimelineEvent *)event;

@end