//
//  CoreDataHelper.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/21/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "CoreDataHelper.h"
#import "AppDelegate.h"

@implementation CoreDataHelper

//Return managed object context
+(NSManagedObjectContext *)managedContext {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return appDelegate.managedObjectContext;
}

+(Worker *)currentUser {
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Worker" inManagedObjectContext:[CoreDataHelper managedContext]];
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:entity];
    
    NSError *error;
    NSArray *array = [[CoreDataHelper managedContext] executeFetchRequest:request error:&error];
    
    Worker *worker = array[0];
    
    return worker;
}

+(void)saveContext {
    NSError *error = nil;
    if (! [[CoreDataHelper managedContext] save:&error]) {
        // Uh, oh. An error happened. :(
        NSLog(@"%@", error.localizedDescription);
    } else {
        NSLog(@"Context Saved");
    }
}

+(NSArray *)fetchUserConnections {
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Worker" inManagedObjectContext:[CoreDataHelper managedContext]];
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:entity];
    
    NSError *error;
    NSArray *array = [[CoreDataHelper managedContext] executeFetchRequest:request error:&error];
    
    Worker *worker = array[0];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"lastName" ascending:YES];
    
    return [[worker valueForKey:@"connections"] sortedArrayUsingDescriptors:@[sortDescriptor]];
}

@end
