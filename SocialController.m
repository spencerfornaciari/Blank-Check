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
        
        if ([sender isKindOfClass:[Worker class]]) {
//            Worker *worker = (Worker *)sender;
            
            [facebookView setInitialText:@"Come check out my value!"];
            


//            [facebookView addImage:gamer.profileImage];
            [facebookView addURL:[NSURL URLWithString:@"http://comingsoon.blankchecklabs.com/"]];
        }
        
        if ([sender isKindOfClass:[Connection class]]) {
            Connection *connection = (Connection *)sender;
        
            [facebookView setInitialText:@"Come check out my value!"];
            [facebookView addImage:[SocialController socialImage:connection]];
            [facebookView addURL:[NSURL URLWithString:@"http://comingsoon.blankchecklabs.com/"]];
        }
        
        return facebookView;
    }
    
    return nil;
}

+(SLComposeViewController *)shareOnTwitter:(id)sender {
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *twitterView = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        if ([sender isKindOfClass:[Worker class]]) {
//            Worker *worker = (Worker *)sender;
            
            [twitterView setInitialText:@"Come check out my value!"];
//            [twitterView addImage:gamer.profileImage];
            [twitterView addURL:[NSURL URLWithString:@"http://comingsoon.blankchecklabs.com/"]];
        }
        
        if ([sender isKindOfClass:[Connection class]]) {
            Connection *connection = (Connection *)sender;
            
            [twitterView setInitialText:@"Come check out my value!"];
            [twitterView addImage:[SocialController socialImage:connection]];
            [twitterView addURL:[NSURL URLWithString:@"http://comingsoon.blankchecklabs.com/"]];
        }
        
        return twitterView;
    }
    
    return nil;
}

+(void)shareOnLinkedin:(id)sender {
    if ([sender isKindOfClass:[Worker class]]) {
//        Worker *worker = (Worker *)sender;

    }
    
    if ([sender isKindOfClass:[Connection class]]) {
//        Connection *connection = (Connection *)sender;

    }
    
//    [[NetworkController sharedController] shareOnLinkedin:gamer];
}

+(UIImage *)socialImage:(id)sender {
    
    if ([sender isKindOfClass:[Connection class]]) {
        Connection *connection = (Connection *)sender;
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:connection.smallImageLocation];
        BOOL fileExists2 = [[NSFileManager defaultManager] fileExistsAtPath:connection.imageLocation];
        
        UIImage *image;
        
        if (fileExists2) {
            image = [UIImage imageWithContentsOfFile:connection.imageLocation];
        } else if (fileExists) {
            image = [UIImage imageWithContentsOfFile:connection.smallImageLocation];
        } else {
            image = [UIImage imageNamed:@"default-user"];
        }
        
        return image;
    }
    
    return nil;
    
}

@end
