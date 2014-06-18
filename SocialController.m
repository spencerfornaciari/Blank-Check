//
//  SocialController.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 6/17/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "SocialController.h"
#import "NetworkController.h"
#import "AppDelegate.h"

@implementation SocialController

+(SLComposeViewController *)shareOnFacebook:(id)sender {
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *facebookView = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        Gamer *gamer = (Gamer *)sender;
        
        [facebookView setInitialText:@"Come check out my value!"];
        [facebookView addImage:gamer.profileImage];
        [facebookView addURL:[NSURL URLWithString:@"http://comingsoon.blankchecklabs.com/"]];
        
        return facebookView;
    }
    
    return nil;
}

+(SLComposeViewController *)shareOnTwitter:(id)sender {
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *twitterView = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        Gamer *gamer = (Gamer *)sender;
        
        [twitterView setInitialText:@"Come check out my value!"];
        [twitterView addImage:gamer.profileImage];
        [twitterView addURL:[NSURL URLWithString:@"http://comingsoon.blankchecklabs.com/"]];
        
        return twitterView;
    }
    
    return nil;
}

+(void)shareOnLinkedin:(id)sender {
    NetworkController *networkController = [(AppDelegate *)[[UIApplication sharedApplication] delegate] networkController];
    
    Gamer *gamer = (Gamer *)sender;
    
    [networkController shareOnLinkedin:gamer];
}

@end
