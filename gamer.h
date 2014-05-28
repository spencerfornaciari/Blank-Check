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
@property (nonatomic) NSInteger *zipCode;
@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) NSString *desiredPosition;

//Linkedin User Information
@property (nonatomic) NSString *gamerID; //Linkedin ID number
@property (nonatomic) NSString *linkedinUsername;
@property (nonatomic) NSString *gamerEmail;
@property (nonatomic) NSURL *linkedinURL;
@property (nonatomic) NSDate *lastLinkedinLogin;

//Gamer photo information
@property (nonatomic) NSURL *imageURL;
@property (nonatomic) NSString *imageLocalLocation;
@property (nonatomic) UIImage *profileImage;

//Gamer's job (level) information
@property (nonatomic) NSMutableArray *valueArray;
@property (nonatomic) NSArray *currentPositionArray;

@property (nonatomic) NSArray *gamerCertifications; //Linkedin Certifications <-- use natural language
@property (nonatomic) NSArray *gamerSkills; //Linkedin Skills <-- use natural language

@property (nonatomic) NSArray *connectionIDArray; //Array of Connections's Linkedin IDs
@property (nonatomic) NSMutableArray *followingIDs; //Create individual graphic experiences
@property (nonatomic) NSArray *educationArray; //Array of educational experience

@property (nonatomic) NSArray *languages;
@property (nonatomic) NSArray *groups;
@property (nonatomic) NSArray *recommendations;

@end