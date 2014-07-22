//
//  Connection.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/22/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Job, Language, School, Value, Worker;

@interface Connection : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * headline;
@property (nonatomic, retain) NSString * imageLocation;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * smallImageLocation;
@property (nonatomic, retain) NSString * smallImageURL;
@property (nonatomic, retain) NSString * linkedinURL;
@property (nonatomic, retain) NSNumber * numConnections;
@property (nonatomic, retain) NSNumber * zipCode;
@property (nonatomic, retain) NSNumber * numRecommenders;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSNumber * invitationSent;
@property (nonatomic, retain) NSDate * lastLinkedinUpdate;
@property (nonatomic, retain) NSString * industry;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) Worker *worker;
@property (nonatomic, retain) NSSet *schools;
@property (nonatomic, retain) NSSet *jobs;
@property (nonatomic, retain) NSSet *languages;
@property (nonatomic, retain) NSOrderedSet *values;
@end

@interface Connection (CoreDataGeneratedAccessors)

- (void)addSchoolsObject:(School *)value;
- (void)removeSchoolsObject:(School *)value;
- (void)addSchools:(NSSet *)values;
- (void)removeSchools:(NSSet *)values;

- (void)addJobsObject:(Job *)value;
- (void)removeJobsObject:(Job *)value;
- (void)addJobs:(NSSet *)values;
- (void)removeJobs:(NSSet *)values;

- (void)addLanguagesObject:(Language *)value;
- (void)removeLanguagesObject:(Language *)value;
- (void)addLanguages:(NSSet *)values;
- (void)removeLanguages:(NSSet *)values;

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

- (void)addNewValueObject:(Value *)value;
@end
