//
//  Education.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 5/29/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Education : NSObject

@property (nonatomic) NSString *schoolName;
@property (nonatomic) NSString *schoolID;
@property (nonatomic) NSString *fieldOfStudy;
@property (nonatomic) NSString *degree;
@property (nonatomic) NSDate *startYear;
@property (nonatomic) NSDate *endYear;

-(instancetype)initWithCoder:(NSCoder *)decoder;
-(void)encodeWithCoder:(NSCoder *)encoder;

@end
