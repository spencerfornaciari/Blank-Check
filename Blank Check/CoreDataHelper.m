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
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    return appDelegate.managedObjectContext;
}

+(Worker *)currentUser {
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Worker" inManagedObjectContext:[CoreDataHelper managedContext]];
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:entityDescription];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstName = %@", @"Spencer"];
    [request setPredicate:predicate];

    Worker *matches = nil;

    NSError *error;

    NSArray *objects = [[CoreDataHelper managedContext] executeFetchRequest:request error:&error];

    NSLog(@"Objects: %u", (unsigned)objects.count);

    if ([objects count] == 0) {
        NSLog(@"No matches");
    } else {
//        NSLog(@"Found a Jessica");
        for (int i = 0; i < objects.count; i++) {
            matches = objects[i];
            NSLog(@"%@ %@ %@", [matches valueForKey:@"firstName"], [matches valueForKey:@"lastName"], [matches valueForKey:@"location"]);
            for (Job *unit in [matches valueForKey:@"jobs"]) {
                NSLog(@"%@", [unit valueForKey:@"companyName"]);
                //I am not at a computer, so I cannot test, but this should work. You might have to access each property of the unit object to fire the fault, but I don't believe that is necessary.
            }
//            NSLog(@"Jobs: %@", );
        }
    }
    
    return [objects firstObject];
}

@end
