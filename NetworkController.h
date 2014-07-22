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

#import "CoreDataHelper.h"
#import "Worker.h"
#import "Job.h"
#import "School.h"
#import "Language.h"
#import "Connection.h"
#import "Value.h"

@protocol NetworkControllerDelegate <NSObject>

-(void)setGamerData;

@end

@interface NetworkController : NSObject <NSURLSessionDelegate, NSURLSessionDataDelegate>

@property (nonatomic) NSString *accessToken;
@property (nonatomic, weak) id<NetworkControllerDelegate>delegate;

+(NetworkController *)sharedController;

//Linkedin API OAuth methods
-(NSString *)beginOAuthAccess;
-(void)handleCallbackURL:(NSString *)code;
-(NSString *)convertURLToCode:(NSURL *)url;
-(BOOL)checkTokenIsCurrent;

//Grabbing user data from Linkedin API
-(void)loadUserData;
//-(Gamer *)loadCurrentUserData;
+(NSArray *)grabUserConnections:(Worker *)worker inContext:(NSManagedObjectContext *)context;
-(NSArray *)commonConnectionsWithUser:(NSString *)userID;

//Social Networking methods
-(void)sendInvitationToUserID:(NSString *)userID;
-(void)shareOnLinkedin:(Gamer *)gamer;

//Textalytics API Calls
-(void)checkProfileText:(NSString *)string;
-(void)listDictionaries;
-(void)readDictionaryWithName:(NSString *)name;

+(NSString *)documentsDirectoryPath;

@end