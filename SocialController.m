//
//  SocialController.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 6/17/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "SocialController.h"

@implementation SocialController

+(SLComposeViewController *)shareOnFacebook:(Gamer *)gamer {
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *facebookView = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [facebookView setInitialText:@"Come check out my value!"];
        [facebookView addImage:gamer.profileImage];
        [facebookView addURL:[NSURL URLWithString:@"http://comingsoon.blankchecklabs.com/"]];
        
        return facebookView;
    }
    
    return nil;
}

+(SLComposeViewController *)shareOnTwitter:(Gamer *)gamer {
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *twitterView = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [twitterView setInitialText:@"Come check out my value!"];
        [twitterView addImage:gamer.profileImage];
        [twitterView addURL:[NSURL URLWithString:@"http://comingsoon.blankchecklabs.com/"]];
        
        return twitterView;
    }
    
    return nil;
}

-(void)shareOnLinkedin {
    
}

@end
