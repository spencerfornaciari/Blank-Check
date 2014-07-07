//
//  TimelineView.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/2/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "TimelineView.h"

@implementation TimelineView

-(id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        
        UILabel *timelineLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 206, 21)];
        timelineLabel.text = @"TIMELINE";
        timelineLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0];
        [self addSubview:timelineLabel];
        
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 280, 21)];
        headerLabel.text = [NSString stringWithFormat:@"Date\t\tEvent\t\tSalary Change"];
        headerLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
        [self addSubview:headerLabel];
        
        UILabel *example = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, 280, 21)];
        example.text = [NSString stringWithFormat:@"June '12\t College Degree\t +20,000"];
        example.font = [UIFont fontWithName:@"HelveticaNeue" size:15.0];
        [example sizeToFit];
        [self addSubview:example];
        
        UILabel *example2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 280, 21)];
        example2.text = [NSString stringWithFormat:@"Dec '13\t iOS Certification\t +15,000"];
        example2.font = [UIFont fontWithName:@"HelveticaNeue" size:15.0];
        [self addSubview:example2];
        
        return self;
    }
    
    return nil;
}

@end
