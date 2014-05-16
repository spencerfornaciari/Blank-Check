//
//  NetworkController.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 5/15/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkController : NSObject

@property (nonatomic) NSString *accessToken;

-(NSString *)beginOAuthAccess;
-(NSString *)handleCallbackURL:(NSString *)code;
-(NSString *)convertURLToCode:(NSURL *)url;


@end
