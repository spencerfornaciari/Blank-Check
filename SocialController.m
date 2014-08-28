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
#import "SocialHelper.h"

@implementation SocialController

//Method for sharing on Facebook
+(SLComposeViewController *)shareOnFacebook:(id)sender {
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *facebookView = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        if ([sender isKindOfClass:[Worker class]]) {
            Worker *worker = (Worker *)sender;
            
            [facebookView setInitialText:@"Come check out my value!"];
            [facebookView addImage:[SocialController socialImage:worker]];
            [facebookView addURL:[NSURL URLWithString:@"http://comingsoon.blankchecklabs.com/"]];
        }
        
        if ([sender isKindOfClass:[Connection class]]) {
            Connection *connection = (Connection *)sender;
        
            [facebookView setInitialText:@"Come check out your value!"];
            [facebookView addImage:[SocialController socialImage:connection]];
            [facebookView addURL:[NSURL URLWithString:@"http://comingsoon.blankchecklabs.com/"]];
        }
        
        return facebookView;
    }
    
    return nil;
}

//Method for sharing on Twitter
+(SLComposeViewController *)shareOnTwitter:(id)sender {
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *twitterView = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        if ([sender isKindOfClass:[Worker class]]) {
            Worker *worker = (Worker *)sender;
            
            [twitterView setInitialText:@"Come check out my value!"];
            [twitterView addImage:[SocialController socialImage:worker]];
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

//Methods for sharing on LinkedIn
+(void)shareOnLinkedin:(id)sender {
    [SocialHelper shareOnLinkedin:sender];
}

//Grabing the user/connection's image
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
    } else {
        Worker *worker = (Worker *)sender;
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:worker.smallImageLocation];
        BOOL fileExists2 = [[NSFileManager defaultManager] fileExistsAtPath:worker.imageLocation];
        
        UIImage *image;
        
        if (fileExists2) {
            image = [UIImage imageWithContentsOfFile:worker.imageLocation];
        } else if (fileExists) {
            image = [UIImage imageWithContentsOfFile:worker.smallImageLocation];
        } else {
            image = [UIImage imageNamed:@"default-user"];
        }
        
        return image;
    }
    
    return [UIImage imageNamed:@"default-user"];
    
}

@end
