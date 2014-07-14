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
#import "Insights.h"

@interface NetworkController : NSObject

@property (nonatomic) NSString *accessToken;

+(NetworkController *)sharedController;

//Linkedin API OAuth methods
-(NSString *)beginOAuthAccess;
-(void)handleCallbackURL:(NSString *)code;
-(NSString *)convertURLToCode:(NSURL *)url;
-(BOOL)checkTokenIsCurrent;

//Grabbing user data from Linkedin API
-(Gamer *)loadCurrentUserData;
+(NSArray *)grabUserConnections;
-(NSArray *)commonConnectionsWithUser:(NSString *)userID;

//Social Networking methods
-(void)sendInvitationToUserID:(NSString *)userID;
-(void)shareOnLinkedin:(Gamer *)gamer;

//Textalytics API Calls
-(void)checkProfileText:(NSString *)string;
-(void)createDictionary;
-(void)listDictionaries;
-(void)readDictionaryWithName:(NSString *)name;
-(void)removeDictionaryWithName:(NSString *)name;
-(void)updateDictionaryWithName:(NSString *)name;

@end