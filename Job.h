//
//  Job.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/21/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Connection, Worker;

@interface Job : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * industry;
@property (nonatomic, retain) NSNumber * isCurrent;
@property (nonatomic, retain) NSNumber * monthsInCurrentJob;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Worker *worker;
@property (nonatomic, retain) Connection *connection;

@end
