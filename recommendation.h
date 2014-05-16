//
//  recommendation.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 5/15/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface recommendation : NSObject

@property (nonatomic) NSString *recommendationText;
@property (nonatomic) NSString *recommendationType;
@property (nonatomic) NSString *recommender; //Ideally we might be able to get the ID # here

@end
