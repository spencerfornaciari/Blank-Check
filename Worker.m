//
//  Worker.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/22/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "Worker.h"
#import "Connection.h"
#import "Job.h"
#import "Language.h"
#import "School.h"
#import "Value.h"


@implementation Worker

@dynamic firstName;
@dynamic headline;
@dynamic imageLocation;
@dynamic imageURL;
@dynamic industry;
@dynamic lastLinkedinUpdate;
@dynamic lastName;
@dynamic linkedinURL;
@dynamic location;
@dynamic numConnections;
@dynamic numRecommenders;
@dynamic smallImageLocation;
@dynamic smallImageURL;
@dynamic zipCode;
@dynamic id;
@dynamic emailAddress;
@dynamic jobs;
@dynamic languages;
@dynamic schools;
@dynamic connections;
@dynamic values;

- (void)addNewValueObject:(Value *)value {
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.values];
    [tempSet addObject:value];
    self.values = tempSet;
}

@end