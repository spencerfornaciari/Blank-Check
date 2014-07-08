//
//  ExpertAppraisal.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/8/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "ExpertAppraisal.h"

@implementation ExpertAppraisal

-(id)init {
    if (self = [super init]) {
        
        self.firstName = @"Jane";
        self.lastName = @"Beeman";
        self.position = @"Recruiter";
        self.location = @"Seattle, WA";
        
        self.profileImage = [UIImage imageNamed:@"default-user"];
        
        return self;
    }
    
    return nil;
}


@end
