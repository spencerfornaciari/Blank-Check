//
//  AppDelegate.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 5/15/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkController.h"
#import "Gamer.h"
#import "UIColor+BlankCheckColors.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NetworkController *networkController;
@property (strong, nonatomic) NSOperationQueue *blankQueue;

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic) Gamer *gamer;
@property (nonatomic) NSURLSession *session;

-(void)saveContext;
-(NSURL *)applicationDocumentsDirectory;

@end
