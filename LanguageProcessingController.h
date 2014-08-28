//
//  LanguageProcessing.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 6/9/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LanguageProcessingController : NSObject

+(NSDictionary *)processWord:(NSString *)string;

+(NSString *)removeCharactersFromString:(NSString *)string;

@end
