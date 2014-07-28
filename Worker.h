//
//  Worker.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/28/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Connection, Insight, Job, Language, Note, Recommendation, School, Value;

@interface Worker : NSManagedObject

@property (nonatomic, retain) NSString * emailAddress;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * headline;
@property (nonatomic, retain) NSString * idNumber;
@property (nonatomic, retain) NSString * imageLocation;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * industry;
@property (nonatomic, retain) NSDate * lastLinkedinUpdate;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * linkedinURL;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSNumber * numConnections;
@property (nonatomic, retain) NSNumber * numRecommenders;
@property (nonatomic, retain) NSString * smallImageLocation;
@property (nonatomic, retain) NSString * smallImageURL;
@property (nonatomic, retain) NSNumber * zipCode;
@property (nonatomic, retain) NSSet *connections;
@property (nonatomic, retain) NSSet *jobs;
@property (nonatomic, retain) NSSet *languages;
@property (nonatomic, retain) NSSet *schools;
@property (nonatomic, retain) NSOrderedSet *values;
@property (nonatomic, retain) NSOrderedSet *insights;
@property (nonatomic, retain) NSOrderedSet *notes;
@property (nonatomic, retain) NSOrderedSet *recommendations;
@end

@interface Worker (CoreDataGeneratedAccessors)

- (void)addConnectionsObject:(Connection *)value;
- (void)removeConnectionsObject:(Connection *)value;
- (void)addConnections:(NSSet *)values;
- (void)removeConnections:(NSSet *)values;

- (void)addJobsObject:(Job *)value;
- (void)removeJobsObject:(Job *)value;
- (void)addJobs:(NSSet *)values;
- (void)removeJobs:(NSSet *)values;

- (void)addLanguagesObject:(Language *)value;
- (void)removeLanguagesObject:(Language *)value;
- (void)addLanguages:(NSSet *)values;
- (void)removeLanguages:(NSSet *)values;

- (void)addSchoolsObject:(School *)value;
- (void)removeSchoolsObject:(School *)value;
- (void)addSchools:(NSSet *)values;
- (void)removeSchools:(NSSet *)values;

- (void)insertObject:(Value *)value inValuesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromValuesAtIndex:(NSUInteger)idx;
- (void)insertValues:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeValuesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInValuesAtIndex:(NSUInteger)idx withObject:(Value *)value;
- (void)replaceValuesAtIndexes:(NSIndexSet *)indexes withValues:(NSArray *)values;
- (void)addValuesObject:(Value *)value;
- (void)removeValuesObject:(Value *)value;
- (void)addValues:(NSOrderedSet *)values;
- (void)removeValues:(NSOrderedSet *)values;
- (void)insertObject:(Insight *)value inInsightsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromInsightsAtIndex:(NSUInteger)idx;
- (void)insertInsights:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeInsightsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInInsightsAtIndex:(NSUInteger)idx withObject:(Insight *)value;
- (void)replaceInsightsAtIndexes:(NSIndexSet *)indexes withInsights:(NSArray *)values;
- (void)addInsightsObject:(Insight *)value;
- (void)removeInsightsObject:(Insight *)value;
- (void)addInsights:(NSOrderedSet *)values;
- (void)removeInsights:(NSOrderedSet *)values;
- (void)insertObject:(Note *)value inNotesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromNotesAtIndex:(NSUInteger)idx;
- (void)insertNotes:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeNotesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInNotesAtIndex:(NSUInteger)idx withObject:(Note *)value;
- (void)replaceNotesAtIndexes:(NSIndexSet *)indexes withNotes:(NSArray *)values;
- (void)addNotesObject:(Note *)value;
- (void)removeNotesObject:(Note *)value;
- (void)addNotes:(NSOrderedSet *)values;
- (void)removeNotes:(NSOrderedSet *)values;
- (void)insertObject:(Recommendation *)value inRecommendationsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromRecommendationsAtIndex:(NSUInteger)idx;
- (void)insertRecommendations:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeRecommendationsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInRecommendationsAtIndex:(NSUInteger)idx withObject:(Recommendation *)value;
- (void)replaceRecommendationsAtIndexes:(NSIndexSet *)indexes withRecommendations:(NSArray *)values;
- (void)addRecommendationsObject:(Recommendation *)value;
- (void)removeRecommendationsObject:(Recommendation *)value;
- (void)addRecommendations:(NSOrderedSet *)values;
- (void)removeRecommendations:(NSOrderedSet *)values;

//My methods
- (void)addNewValueObject:(Value *)value;
- (void)addNewInsightObject:(Insight *)value;
- (void)addNewNoteObject:(Note *)value;
- (void)addNewRecommendationObject:(Recommendation *)value;
@end
