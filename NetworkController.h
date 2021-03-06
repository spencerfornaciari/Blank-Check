//
//  NetworkController.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 5/15/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CoreDataHelper.h"
#import "Worker.h"
#import "Job.h"
#import "School.h"
#import "Language.h"
#import "Connection.h"
#import "Value.h"
#import "Recommendation.h"
#import "Insight.h"
#import "LocationController.h"

@protocol NetworkControllerDelegate <NSObject>

-(void)setGamerData;

@end

@interface NetworkController : NSObject <NSURLSessionDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate>

@property (nonatomic) NSString *accessToken;
@property (nonatomic, weak) id<NetworkControllerDelegate>delegate;
@property (nonatomic) NSURLSession *session;

+(NetworkController *)sharedController;

//Linkedin API OAuth methods
-(NSString *)beginOAuthAccess;
-(void)handleCallbackURL:(NSString *)code;
-(NSString *)convertURLToCode:(NSURL *)url;
-(BOOL)checkTokenIsCurrent;
-(void)checkTokenIsCurrentWithCallback:(void (^)(BOOL finished))completion;

//Grabbing user data from Linkedin API
-(void)loadUserData;
-(void)grabUserConnections:(Worker *)worker inContext:(NSManagedObjectContext *)context atRange:(NSInteger)range;
-(NSArray *)commonConnectionsWithUser:(NSString *)userID;

+(NSString *)documentsDirectoryPath;

@end