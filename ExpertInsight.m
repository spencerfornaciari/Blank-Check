//
//  ExpertInsightModel.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/8/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "ExpertInsight.h"

@implementation ExpertInsight

-(id)init {
    if (self = [super init]) {
        
        self.firstName = @"Johnny";
        self.lastName = @"Appleseed";
        self.position = @"Expert";
        self.company = @"Apple, Inc";
        self.location = @"Cupertino, CA";
        self.comments = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
        
        self.profileImage = [UIImage imageNamed:@"default-user"];
        
        return self;
    }
    
    return nil;
}

@end
