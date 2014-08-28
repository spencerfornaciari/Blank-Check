//
//  LoadingView.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/7/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "LoadingView.h"

@implementation LoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self configureView];
    }
    return self;
}

//Loading view while information Linkedin downloads
-(void)configureView{
    
    self.backgroundColor = [UIColor blackColor];
    self.alpha = 0.5;
    self.layer.cornerRadius = self.frame.size.width / 7;
    self.layer.masksToBounds = TRUE;

    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.activityIndicator setCenter:CGPointMake(self.bounds.origin.x + self.frame.size.width / 2, self.bounds.origin.y + self.frame.size.height / 3)];
    self.activityIndicator.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.activityIndicator];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.activityIndicator.frame.origin.y + 50, self.frame.size.width, 21)];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.text = @"Loading";
    
    [self addSubview:label];
}

@end
