//
//  Position.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 5/28/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "Position.h"

@implementation Position

-(instancetype)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init])
    {
        self.idNumber = [decoder decodeObjectForKey:@"idNumber"];
        self.title = [decoder decodeObjectForKey:@"title"];
        self.industry = [decoder decodeObjectForKey:@"industry"];
        self.summary = [decoder decodeObjectForKey:@"summary"];
        self.startDate = [decoder decodeObjectForKey:@"startDate"];
        self.endDate = [decoder decodeObjectForKey:@"endDate"];
        self.monthsInCurrentJob = [decoder decodeFloatForKey:@"monthsInCurrentJob"];
        self.isCurrent = [decoder decodeBoolForKey:@"isCurrent"];
        self.companyName = [decoder decodeObjectForKey:@"companyName"];
        
        return self;
    }
    
    return nil;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.idNumber forKey:@"idNumber"];
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.industry forKey:@"industry"];
    [encoder encodeObject:self.summary forKey:@"summary"];
    
    [encoder encodeObject:self.startDate forKey:@"startDate"];
    [encoder encodeObject:self.endDate forKey:@"endDate"];
    [encoder encodeFloat:self.monthsInCurrentJob forKey:@"monthsInCurrentJob"];
    [encoder encodeBool:self.isCurrent forKey:@"isCurrent"];
    
    [encoder encodeObject:self.companyName forKey:@"companyName"];

    
}

@end
