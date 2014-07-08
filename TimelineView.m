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
//        [dateformatter setDateFormat:@"LLL 'yy"];
        [dateformatter setDateStyle:NSDateFormatterShortStyle];
        NSString *theDate = [dateformatter stringFromDate:event.dateOfEvent];

        UILabel *example = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 280, 21)];
        
        if (event.amountOfChange > 0) {
            example.text = [NSString stringWithFormat:@"%@\t%@\t+%ld", theDate, event.event, (long)event.amountOfChange];
        } else {
            example.text = [NSString stringWithFormat:@"%@\t%@\t%ld", theDate, event.event, (long)event.amountOfChange];
        }
        
        example.font = [UIFont fontWithName:@"HelveticaNeue" size:15.0];
        [example sizeToFit];
        [self addSubview:example];
        
        return self;
    }
    
    return nil;
}

@end
