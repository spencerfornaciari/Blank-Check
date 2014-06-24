//
//  Gamer.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 5/28/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Gamer : NSObject

//Gamer Information
@property (nonatomic) NSInteger *zipCode; //Not part of LinkedIn API
@property (nonatomic) NSString *location;
@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) NSString *fullName;
@property (nonatomic) NSString *desiredPosition;
@property (nonatomic) NSNumber *numConnections;
@property (nonatomic) NSNumber *numRecommenders;

//For connections
@property (nonatomic) NSString *headline;
@property (nonatomic) NSString *industry;

//Linkedin User Information
@property (nonatomic) NSString *gamerID; //Linkedin ID number
@property (nonatomic) NSString *linkedinUsername;
@property (nonatomic) NSString *gamerEmail;
@property (nonatomic) NSURL *linkedinURL;
@property (nonatomic) NSDate *lastLinkedinUpdate;

//Gamer photo information
@property (nonatomic) NSURL *imageURL;
@property (nonatomic) NSURL *smallImageURL;
@property (nonatomic) NSString *imageLocalLocation;
@property (nonatomic) NSString *smallImageLocalLocation;
@property (nonatomic) UIImage *profileImage;
@property (nonatomic) UIImage *smallProfileImage;

//Gamer's job (level) information
@property (nonatomic) NSMutableArray *valueArray;
@property (nonatomic) NSArray *currentPositionArray;

@property (nonatomic) NSArray *gamerCertifications; //Linkedin Certifications <-- use natural language
@property (nonatomic) NSMutableArray *gamerSkills; //Linkedin Skills <-- use natural language

@property (nonatomic) NSMutableArray *connectionIDArray; //Array of Connections's Linkedin IDs
@property (nonatomic) NSMutableArray *followingIDs; //Create individual graphic experiences
@property (nonatomic) NSMutableArray *educationArray; //Array of educational experience

@property (nonatomic) NSMutableArray *gamerLanguages;
@property (nonatomic) NSArray *groups;
@property (nonatomic) NSMutableArray *gamerRecommendations;

@end