//
//  School.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/20/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface School : NSManagedObject

@property (nonatomic, retain) NSString * schoolName;
@property (nonatomic, retain) NSNumber * schoolID;
@property (nonatomic, retain) NSString * fieldOfStudy;
@property (nonatomic, retain) NSString * degree;
@property (nonatomic, retain) NSDate * startYear;
@property (nonatomic, retain) NSDate * endYear;

@end
