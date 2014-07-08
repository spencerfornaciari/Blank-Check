//
//  TimelineEvent.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/8/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "TimelineEvent.h"

@implementation TimelineEvent

-(id)initWithEvent:(NSString *)event onDate:(NSDate *)date withChange:(NSInteger)change {
    if (self = [super init]) {
        self.event = event;
        self.dateOfEvent = date;
        self.amountOfChange = change;
        
        return self;
    }
    
    return nil;
}

@end
