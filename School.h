//
//  School.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/21/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Connection, Worker;

@interface School : NSManagedObject

@property (nonatomic, retain) NSString * degree;
@property (nonatomic, retain) NSDate * endYear;
@property (nonatomic, retain) NSString * fieldOfStudy;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * startYear;
@property (nonatomic, retain) Worker *worker;
@property (nonatomic, retain) Connection *connection;

@end
