//
//  CoreDataHelper.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/21/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Worker.h"

@interface CoreDataHelper : NSObject

+(NSManagedObjectContext *)managedContext;
+(Worker *)currentUser;
+(void)saveContext;

@end
