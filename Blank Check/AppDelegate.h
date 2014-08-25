//
//  AppDelegate.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 5/15/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import "NetworkController.h"
#import "UIColor+BlankCheckColors.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, NSURLSessionDelegate>

@property (strong, nonatomic) UIWindow *window;
//@property (strong, nonatomic) NetworkController *networkController;
@property (strong, nonatomic) NSOperationQueue *blankQueue;

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic) NSURLSession *session;
@property (nonatomic) ACAccountStore *accounts;

-(void)saveContext;
-(NSURL *)applicationDocumentsDirectory;

@end
