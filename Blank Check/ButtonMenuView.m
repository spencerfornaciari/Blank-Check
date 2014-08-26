//
//  ButtonMenuView.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 8/25/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "ButtonMenuView.h"

@implementation ButtonMenuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSLog(@"Frame: %@", NSStringFromCGRect(frame));
        
        self.followButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.followButton.frame = CGRectMake(0, 0, 56, 56);
        [self.followButton setImage:[UIImage imageNamed:@"follow"] forState:UIControlStateNormal];
//        [self.followButton addTarget:self action:@selector(followAction) forControlEvents:UIControlEventTouchUpInside];
        self.followButton.layer.borderWidth = 1.0;
        self.followButton.layer.borderColor = [UIColor blackColor].CGColor;
        [self addSubview:self.followButton];
        
        UILabel *followLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 61, 56, 21)];
        followLabel.text = @"Follow";
        followLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:11.0];
        followLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:followLabel];
        
        self.outButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.outButton.frame = CGRectMake(56, 0, 56, 56);
        [self.outButton setImage:[UIImage imageNamed:@"remove"] forState:UIControlStateNormal];
        [self.outButton setImageEdgeInsets:UIEdgeInsetsMake(14, 14, 14, 14)];

//        [self.outButton addTarget:self action:@selector(outAction) forControlEvents:UIControlEventTouchUpInside];
        self.outButton.layer.borderWidth = 1.0;
        self.outButton.layer.borderColor = [UIColor blackColor].CGColor;
        [self addSubview:self.outButton];
        
        UILabel *outLabel = [[UILabel alloc] initWithFrame:CGRectMake(56, 61, 56, 21)];
        outLabel.text = @"X-Out";
        outLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:11.0];
        outLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:outLabel];
        
        self.noteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.noteButton.frame = CGRectMake(112, 0, 56, 56);
        [self.noteButton setImage:[UIImage imageNamed:@"notes"] forState:UIControlStateNormal];
        [self.noteButton setImageEdgeInsets:UIEdgeInsetsMake(12, 12, 12, 12)];
//        [self.noteButton addTarget:self action:@selector(noteAction) forControlEvents:UIControlEventTouchUpInside];
        self.noteButton.layer.borderWidth = 1.0;
        self.noteButton.layer.borderColor = [UIColor blackColor].CGColor;
        [self addSubview:self.noteButton];
        
        UILabel *noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(112, 61, 56, 21)];
        noteLabel.text = @"Note";
        noteLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:11.0];
        noteLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:noteLabel];
        
        self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.shareButton.frame = CGRectMake(168, 0, 56, 56);
        [self.shareButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
        [self.shareButton setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 12, 10)];

//        [self.shareButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
        self.shareButton.layer.borderWidth = 1.0;
        self.shareButton.layer.borderColor = [UIColor blackColor].CGColor;
        [self addSubview:self.shareButton];
        
        UILabel *shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(168, 61, 56, 21)];
        shareLabel.text = @"Share";
        shareLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:11.0];
        shareLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:shareLabel];
        
        self.findSimilarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.findSimilarButton.frame = CGRectMake(224, 0, 56, 56);
        [self.findSimilarButton setImage:[UIImage imageNamed:@"similar"] forState:UIControlStateNormal];
        [self.findSimilarButton setImageEdgeInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
//        [self.findSimilarButton addTarget:self action:@selector(findSimilarAction) forControlEvents:UIControlEventTouchUpInside];
        self.findSimilarButton.layer.borderWidth = 1.0;
        self.findSimilarButton.layer.borderColor = [UIColor blackColor].CGColor;
        [self addSubview:self.findSimilarButton];
        
        UILabel *findSimilarLabel = [[UILabel alloc] initWithFrame:CGRectMake(224, 61, 60, 21)];
        findSimilarLabel.text = @"Find Similar";
        findSimilarLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:11.0];
        findSimilarLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:findSimilarLabel];

    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
