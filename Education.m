//
//  Education.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 5/29/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "Education.h"

@implementation Education

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.schoolName = [decoder decodeObjectForKey:@"schoolName"];
        self.schoolID = [decoder decodeObjectForKey:@"schoolID"];
        self.fieldOfStudy = [decoder decodeObjectForKey:@"fieldOfStudy"];
        self.degree = [decoder decodeObjectForKey:@"degree"];
        self.startYear = [decoder decodeObjectForKey:@"startYear"];
        self.endYear = [decoder decodeObjectForKey:@"endYear"];
        
        return self;
    }
    
    return nil;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.schoolName forKey:@"schoolName"];
    [encoder encodeObject:self.schoolID forKey:@"schoolID"];
    [encoder encodeObject:self.fieldOfStudy forKey:@"fieldOfStudy"];
    [encoder encodeObject:self.degree forKey:@"degree"];
    [encoder encodeObject:self.startYear forKey:@"startYear"];
    [encoder encodeObject:self.endYear forKey:@"endYear"];
}

@end
