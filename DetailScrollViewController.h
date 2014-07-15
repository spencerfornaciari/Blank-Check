//
//  DetailScrollViewController.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 6/23/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GraphKit.h>
#import "Gamer.h"
#import "ExpertInsightView.h"
#import "ExpertAppraisalView.h"
#import "UserInfoView.h"
#import "TimelineView.h"

@interface DetailScrollViewController : UIViewController <UIScrollViewDelegate,GKLineGraphDataSource, UIActionSheetDelegate> {
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIImageView *profileImage;
    IBOutlet UILabel *userNameLabel;
    IBOutlet UILabel *valueLabel; 
}

@property (nonatomic) Gamer *gamer;

@end
