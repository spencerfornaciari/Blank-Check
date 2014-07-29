//
//  CoreDataHelper.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/21/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Worker.h"
#import "Connection.h"

@interface CoreDataHelper : NSObject

//Manage Context
+(NSManagedObjectContext *)managedContext;

//User Methods
+(Worker *)currentUser;
+(NSArray *)fetchUserConnections;

//Save Context
+(void)saveContext;

@end
