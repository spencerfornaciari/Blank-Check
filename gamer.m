//
//  Gamer.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 5/28/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "Gamer.h"

@implementation Gamer

-(instancetype)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init])
    {
        
        /*@property (nonatomic) NSInteger *zipCode; //Not part of LinkedIn API
         @property (nonatomic) NSString *desiredPosition;
         @property (nonatomic) NSNumber *numRecommenders;
         
         //For connections
         @property (nonatomic) NSString *headline;
         @property (nonatomic) NSString *industry;
         
         //Linkedin User Information
         @property (nonatomic) NSString *gamerID; //Linkedin ID number
         
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
         @property (nonatomic) NSMutableArray *gamerRecommendations;*/

        self.firstName = [decoder decodeObjectForKey:@"firstName"];
        self.lastName = [decoder decodeObjectForKey:@"lastName"];
        self.fullName = [decoder decodeObjectForKey:@"fullName"];
        self.location = [decoder decodeObjectForKey:@"location"];
        self.numConnections = [decoder decodeObjectForKey:@"numConnections"];
        
        self.gamerEmail = [decoder decodeObjectForKey:@"gamerEmail"];
        self.linkedinUsername = [decoder decodeObjectForKey:@"linkedinUsername"];
        self.linkedinURL = [decoder decodeObjectForKey:@"linkedinURL"];
        self.lastLinkedinUpdate = [decoder decodeObjectForKey:@"lastLinkedinUpdate"];

        self.imageURL = [decoder decodeObjectForKey:@"imageURL"];
        self.smallImageURL = [decoder decodeObjectForKey:@"smallImageURL"];
        self.imageLocalLocation = [decoder decodeObjectForKey:@"imageLocalLocation"];
        self.smallImageLocalLocation = [decoder decodeObjectForKey:@"smallImageLocalLocation"];

        self.valueArray = [decoder decodeObjectForKey:@"valueArray"];
//        self.currentPositionArray = [decoder decodeObjectForKey:@"currentPositionArray"];
//        
        self.connectionIDArray = [decoder decodeObjectForKey:@"connectionIDArray"];
//        self.educationArray = [decoder decodeObjectForKey:@"educationArray"];
//        
//        self.gamerLanguages = [decoder decodeObjectForKey:@"gamerLanguages"];
//        self.gamerRecommendations = [decoder decodeObjectForKey:@"gamerRecommendations"];
        
        self.invitationSent = [decoder decodeBoolForKey:@"invitationSent"];
        
        return self;
    }
    
    return nil;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.firstName forKey:@"firstName"];
    [encoder encodeObject:self.lastName forKey:@"lastName"];
    [encoder encodeObject:self.fullName forKey:@"fullName"];
    [encoder encodeObject:self.location forKey:@"location"];
    [encoder encodeObject:self.numConnections forKey:@"numConnections"];
    
    [encoder encodeObject:self.gamerEmail forKey:@"gamerEmail"];
    [encoder encodeObject:self.linkedinUsername forKey:@"linkedinUsername"];
    [encoder encodeObject:self.linkedinURL forKey:@"linkedinURL"];
    [encoder encodeObject:self.lastLinkedinUpdate forKey:@"lastLinkedinUpdate"];

    [encoder encodeObject:self.imageURL forKey:@"imageURL"];
    [encoder encodeObject:self.smallImageURL forKey:@"smallImageURL"];
    [encoder encodeObject:self.imageLocalLocation forKey:@"imageLocalLocation"];
    [encoder encodeObject:self.smallImageLocalLocation forKey:@"smallImageLocalLocation"];

    [encoder encodeObject:self.valueArray forKey:@"valueArray"];
//    [encoder encodeObject:self.currentPositionArray forKey:@"currentPositionArray"];
//    
    [encoder encodeObject:self.connectionIDArray forKey:@"connectionIDArray"];
//    [encoder encodeObject:self.educationArray forKey:@"educationArray"];
//    
//    [encoder encodeObject:self.gamerLanguages forKey:@"gamerLanguages"];
//    [encoder encodeObject:self.gamerRecommendations forKey:@"gamerRecommendations"];
    
    [encoder encodeBool:self.invitationSent forKey:@"invitationSent"];
}

+(NSString *)documentsDirectoryPath
{
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    return [documentsURL path];
}

+(NSString *)gamerPath {
    return [[self documentsDirectoryPath] stringByAppendingPathComponent:@"currentGamer"];
}
@end
