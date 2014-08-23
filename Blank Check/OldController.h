//
//  OldController.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 8/23/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OldController : NSObject

//Textalytics API Calls
+(NSArray *)checkProfileText:(NSString *)string;
-(void)listDictionaries;
-(void)readDictionaryWithName:(NSString *)name;

@end
