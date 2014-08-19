//
//  ValueController.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 8/19/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ValueController : NSObject

+(NSString *)careerSearch:(id)sender;

+(NSArray *)jobValue:(NSString *)title;

+(NSArray *)generateBackValues:(NSNumber *)value;

@end