//
//  TimelineEvent.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/8/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimelineEvent : NSObject

@property (nonatomic) NSString *event;
@property (nonatomic) NSInteger amountOfChange;
@property (nonatomic) NSDate *dateOfEvent;

-(id)initWithEvent:(NSString *)event onDate:(NSDate *)date withChange:(NSInteger)change;

@end
