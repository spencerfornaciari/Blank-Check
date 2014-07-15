//
//  Position.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 5/28/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Position : NSObject

@property (nonatomic) NSString *idNumber;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *industry;
@property (nonatomic) NSString *summary;
@property (nonatomic) NSDate *startDate;
@property (nonatomic) NSDate *endDate;
@property (nonatomic) float monthsInCurrentJob;
@property (nonatomic) BOOL isCurrent;
@property (nonatomic) NSString *companyName;

-(instancetype)initWithCoder:(NSCoder *)decoder;
-(void)encodeWithCoder:(NSCoder *)encoder;

@end