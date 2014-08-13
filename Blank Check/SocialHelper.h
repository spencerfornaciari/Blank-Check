//
//  SocialHelper.h
//
//  Created by Spencer Fornaciari on 8/12/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "AppDelegate.h"

@interface SocialHelper : NSObject
+(ACAccountStore *)accessAccountStore;

//Twitter Sharing
+(BOOL)checkTwitterAccount;
+(ACAccount *)twitterAccount;
+(ACAccount *)accessTwitterAccount;
+(void)sendTwitterPost:(id)sender;

//Facebook Sharing
+(BOOL)checkFacebookAccount;
+(ACAccount *)facebookAccount;
+(ACAccount *)accessFacebookAccount;
+(void)sendFacebookPost:(id)sender;

//Linkedin Sharing
+(void)shareOnLinkedin:(id)sender;
+(void)sendInvitationToUserID:(id)sender;

@end
