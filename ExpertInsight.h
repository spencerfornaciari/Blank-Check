//
//  ExpertInsightModel.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/8/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExpertInsight : NSObject

@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) NSString *position;
@property (nonatomic) NSString *company;
@property (nonatomic) NSString *location;
@property (nonatomic) NSString *comments;

@property (nonatomic) UIImage *profileImage;

@end
