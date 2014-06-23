//
//  NetworkController.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 5/15/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Gamer.h"
#import "Position.h"
#import "Education.h"
#import "Language.h"
#import "Recommendation.h"

@interface NetworkController : NSObject

@property (nonatomic) NSString *accessToken;

-(NSString *)beginOAuthAccess;
-(void)handleCallbackURL:(NSString *)code;
-(NSString *)convertURLToCode:(NSURL *)url;
-(BOOL)checkTokenIsCurrent;

-(Gamer *)loadCurrentUserData;
-(void)sendInvitationToUserID:(NSString *)userID;
-(void)shareOnLinkedin:(Gamer *)gamer;
-(NSArray *)commonConnectionsWithUser:(NSString *)userID;

@end