//
//  NSURLSessionHelper.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 8/25/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "NSURLSessionHelper.h"

@implementation NSURLSessionHelper

+(NSURLSession *)getNSURLSession {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSURLSession *session = appDelegate.session;
    
    return session;
}

@end
