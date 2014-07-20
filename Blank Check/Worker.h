//
//  Worker.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/18/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


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
@end

@interface Worker (CoreDataGeneratedAccessors)

- (void)addJobsObject:(NSManagedObject *)value;
- (void)removeJobsObject:(NSManagedObject *)value;
- (void)addJobs:(NSSet *)values;
- (void)removeJobs:(NSSet *)values;

@end
