//
//  Insight.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/28/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Connection, Worker;

@interface Insight : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * position;
@property (nonatomic, retain) NSString * company;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * comments;
@property (nonatomic, retain) NSString * profileImage;
@property (nonatomic, retain) Worker *worker;
@property (nonatomic, retain) Connection *connection;

@end
