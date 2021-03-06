//
//  Value.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/23/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Connection, Worker;

@interface Value : NSManagedObject

@property (nonatomic, retain) NSNumber * change;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * marketPrice;
@property (nonatomic, retain) Connection *connection;
@property (nonatomic, retain) Worker *worker;

@end
