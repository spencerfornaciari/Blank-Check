//
//  Worker.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/28/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "Worker.h"
#import "Connection.h"
#import "Insight.h"
#import "Job.h"
#import "Language.h"
#import "Note.h"
#import "Recommendation.h"
#import "School.h"
#import "Value.h"


@implementation Worker

@dynamic emailAddress;
@dynamic firstName;
@dynamic headline;
@dynamic idNumber;
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
@dynamic connections;
@dynamic jobs;
@dynamic languages;
@dynamic schools;
@dynamic values;
@dynamic insights;
@dynamic notes;
@dynamic recommendations;

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

@end
