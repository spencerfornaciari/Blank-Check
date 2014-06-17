//
//  SocialController.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 6/17/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Social/Social.h>
#import "Gamer.h"

@interface SocialController : NSObject

+(SLComposeViewController *)shareOnFacebook:(id)sender;
+(SLComposeViewController *)shareOnTwitter:(id)sender;
+(void)shareOnLinkedin:(id)sender;

@end
