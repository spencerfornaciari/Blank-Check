//
//  level.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 5/15/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface level : NSObject

@property (nonatomic) NSString *levelTitle;
@property (nonatomic) NSDate *levelStartDate;
@property (nonatomic) NSDate *levelEndDate;
@property (nonatomic) BOOL *levelCurrent;
@property (nonatomic) NSInteger *levelLength; //In months
@property (nonatomic) NSString *levelCompanyName; //Company name

@end
