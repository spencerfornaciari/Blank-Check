//
//  recommendation.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 5/15/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Recommendation : NSObject

@property (nonatomic) NSString *recommendationID;
@property (nonatomic) NSString *recommendationText;
@property (nonatomic) NSString *recommendationType;
@property (nonatomic) NSString *recommenderID;
@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;

@end
