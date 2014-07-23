//
//  Language.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/23/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Connection, Worker;

@interface Language : NSManagedObject

@property (nonatomic, retain) NSNumber * idNumber;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * proficiency;
@property (nonatomic, retain) Connection *connection;
@property (nonatomic, retain) Worker *worker;

@end
