//
//  Connection.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 8/21/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "Connection.h"
#import "Insight.h"
#import "Job.h"
#import "Language.h"
#import "Note.h"
#import "Recommendation.h"
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
@dynamic city;
@dynamic state;
@dynamic county;
@dynamic country;
@dynamic locationAvailable;
@dynamic insights;
@dynamic jobs;
@dynamic languages;
@dynamic notes;
@dynamic recommendations;
@dynamic schools;
@dynamic values;
@dynamic worker;

- (void)addNewValueObject:(Value *)value {
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.values];
    [tempSet addObject:value];
    self.values = tempSet;
}

- (void)addNewInsightObject:(Insight *)value {
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.insights];
    [tempSet addObject:value];
    self.insights = tempSet;
}

- (void)addNewNoteObject:(Note *)value {
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.notes];
    [tempSet addObject:value];
    self.notes = tempSet;
}

- (void)addNewRecommendationObject:(Recommendation *)value {
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.recommendations];
    [tempSet addObject:value];
    self.recommendations = tempSet;
}

- (void)addNewJobObject:(Job *)value {
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.jobs];
    [tempSet addObject:value];
    self.jobs = tempSet;
}

@end
