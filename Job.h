//
//  Job.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/20/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Job : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * companyName;
@property (nonatomic, retain) NSNumber * idNumber;
@property (nonatomic, retain) NSNumber * monthsInCurrentJob;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSNumber * isCurrent;
@property (nonatomic, retain) NSString * industry;
@property (nonatomic, retain) NSString * summary;

@end
