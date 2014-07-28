//
//  Recommendation.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/28/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Connection, Worker;

@interface Recommendation : NSManagedObject

@property (nonatomic, retain) NSString * idNumber;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * recommenderID;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) Worker *worker;
@property (nonatomic, retain) Connection *connection;

@end
