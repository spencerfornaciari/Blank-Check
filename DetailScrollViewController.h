//
//  DetailScrollViewController.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 6/23/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GraphKit.h>
#import "SocialHelper.h"
#import "NetworkController.h"
#import "ExpertInsightView.h"
#import "ExpertAppraisalView.h"
#import "UserInfoView.h"
#import "TimelineView.h"
#import "Connection.h"

@interface DetailScrollViewController : UIViewController <UIScrollViewDelegate, UIActionSheetDelegate, NSURLSessionDelegate, NSURLSessionDownloadDelegate, UITextFieldDelegate, UIAlertViewDelegate, GKLineGraphDataSource> {
    IBOutlet UIScrollView *scrollView;
    IBOutlet UILabel *userNameLabel;
    IBOutlet UILabel *valueLabel; 
}

@property (nonatomic) Connection *connection;
@property (nonatomic) Worker *worker;

@property (nonatomic) id detail;

@end