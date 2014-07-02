//
//  Insights.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/1/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Insights : NSObject

@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *evaluation;

@property (nonatomic) NSURL *imageURL;
@property (nonatomic) NSString *imageLocalLocation;

@end