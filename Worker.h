//
//  Worker.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/20/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Job, School;

@interface Worker : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSNumber * invitationSent;
@property (nonatomic, retain) NSNumber * numConnections;
@property (nonatomic, retain) NSNumber * numRecommenders;
@property (nonatomic, retain) NSNumber * zipCode;
@property (nonatomic, retain) NSDate * lastLinkedinUpdate;
@property (nonatomic, retain) NSString * headline;
@property (nonatomic, retain) NSString * imageLocation;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * smallImageLocation;
@property (nonatomic, retain) NSString * smallImageURL;
@property (nonatomic, retain) NSString * linkedinURL;
@property (nonatomic, retain) NSString * industry;
@property (nonatomic, retain) NSSet *jobs;
@property (nonatomic, retain) NSSet *languages;
@property (nonatomic, retain) NSSet *schools;
@end

@interface Worker (CoreDataGeneratedAccessors)

- (void)addJobsObject:(Job *)value;
- (void)removeJobsObject:(Job *)value;
- (void)addJobs:(NSSet *)values;
- (void)removeJobs:(NSSet *)values;

- (void)addLanguagesObject:(NSManagedObject *)value;
- (void)removeLanguagesObject:(NSManagedObject *)value;
- (void)addLanguages:(NSSet *)values;
- (void)removeLanguages:(NSSet *)values;

- (void)addSchoolsObject:(School *)value;
- (void)removeSchoolsObject:(School *)value;
- (void)addSchools:(NSSet *)values;
- (void)removeSchools:(NSSet *)values;

@end
