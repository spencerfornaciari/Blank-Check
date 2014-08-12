//
//  SocialHelper.h
//  Dial
//
//  Created by Spencer Fornaciari on 8/12/14.
//  Copyright (c) 2014 Dial. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "AppDelegate.h"

@interface SocialHelper : NSObject
+(ACAccountStore *)accessAccountStore;

+(ACAccount *)checkTwitterAccount;
+(ACAccount *)accessTwitterAccount;
+(void)sendTwitterPost:(id)sender;

+(ACAccount *)checkFacebookAccount;
+(ACAccount *)accessFacebookAccount;
+(void)sendFacebookPost:(id)sender;

+(void)shareOnLinkedin:(id)sender;

@end
