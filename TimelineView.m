//
//  TimelineView.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/2/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "TimelineView.h"

@implementation TimelineView

-(id)initWithFrame:(CGRect)frame andTimelineEvent:(TimelineEvent *)event {
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        
        NSDateFormatter *dateformatter = [NSDateFormatter new];
        [dateformatter setDateFormat:@"MMM ''yy"];
        NSString *theDate = [dateformatter stringFromDate:event.dateOfEvent];

        UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.origin.x + 10, 0, 40, 21)];
        date.text = [NSString stringWithFormat:@"%@", theDate];
        date.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
        [date sizeToFit];
        [self addSubview:date];
        
        UILabel *eventDetails = [[UILabel alloc] initWithFrame:CGRectMake(date.frame.origin.x + 70, 0, 100, 21)];
        eventDetails.text = event.event;
        eventDetails.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
        [eventDetails sizeToFit];
        [self addSubview:eventDetails];
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSString *formattedNumberString = [numberFormatter stringFromNumber:event.amountOfChange];
        
        UILabel *performanceChange = [[UILabel alloc] initWithFrame:CGRectMake(eventDetails.frame.origin.x + 120, 0, 100, 21)];
        
        if ([event.amountOfChange integerValue] > 0) {
            performanceChange.text = [NSString stringWithFormat:@"+%@", formattedNumberString];
        } else {
            performanceChange.text = [NSString stringWithFormat:@"%@", formattedNumberString];
        }
        
        performanceChange.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
        [performanceChange sizeToFit];
        [self addSubview:performanceChange];
        
        
        return self;
    }
    
    return nil;
}

@end
