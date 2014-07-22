//
//  FeedTableViewCell.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 6/18/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Gamer.h"
#import "Connection.h"
#import "Value.h"

@interface FeedTableViewCell : UITableViewCell <NSURLSessionDelegate, NSURLSessionDownloadDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *profileImage;

@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;

@property (nonatomic) Connection *connection;

-(void)setCell:(Connection *)connection;

@end
