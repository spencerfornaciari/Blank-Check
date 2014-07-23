//
//  Connection.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/23/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "Connection.h"
#import "Job.h"
#import "Language.h"
#import "School.h"
#import "Value.h"
#import "Worker.h"


@implementation Connection

@dynamic distance;
@dynamic firstName;
@dynamic headline;
@dynamic idNumber;
@dynamic imageLocation;
@dynamic imageURL;
@dynamic industry;
@dynamic invitationSent;
@dynamic lastLinkedinUpdate;
@dynamic lastName;
@dynamic linkedinURL;
@dynamic location;
@dynamic numConnections;
@dynamic numRecommenders;
@dynamic smallImageLocation;
@dynamic smallImageURL;
@dynamic zipCode;
@dynamic jobs;
@dynamic languages;
@dynamic schools;
@dynamic values;
@dynamic worker;

- (void)addNewValueObject:(Value *)value {
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.values];
    [tempSet addObject:value];
    self.values = tempSet;
}

@end
