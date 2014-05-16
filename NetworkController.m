//
//  NetworkController.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 5/15/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "NetworkController.h"

#define LINKEDIN_OAUTH_URL @"https://www.linkedin.com/uas/oauth2/authorization?response_type=code"
#define LINKEDIN_TOKEN_URL @"https://www.linkedin.com/uas/oauth2/accessToken?grant_type=authorization_code"

#define LINKEDIN_REDIRECT @"http://MacGuff.in"
//#define LINKEDIN_REDIRECT @"blankcheck://linkedin_callback"

#define LINKEDIN_SCOPE @"r_fullprofile%20r_emailaddress%20r_network%20r_contactinfo"

@implementation NetworkController{
    NSString *authorizationCode;
}

+ (NetworkController *)sharedController
{
    static dispatch_once_t pred;
    static NetworkController *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[NetworkController alloc] init];
    });
    return shared;
}

-(NSString *)beginOAuthAccess
{
    
    /*https://www.linkedin.com/uas/oauth2/authorization?response_type=code
    &client_id=YOUR_API_KEY
    &scope=SCOPE
    &state=STATE
    &redirect_uri=YOUR_REDIRECT_URI*/
    
    NSString *authorizationURL = [NSString stringWithFormat:@"%@&client_id=%@&scope=%@&state=%@&redirect_uri=%@", LINKEDIN_OAUTH_URL, kLINKEDIN_API_KEY, LINKEDIN_SCOPE, kLINKEDIN_STATE, LINKEDIN_REDIRECT];
    
//    NSLog(@"%@", authorizationURL);
    
    return authorizationURL;
    
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authorizationURL]];
    
//    return authorizationURL;
                       //LINKED_CLIENT_ID, GITHUB_REDIRECT, @"user,repo"];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:myURL]];
}

-(NSString *)handleCallbackURL:(NSString *)code
{
//    //YOUR_REDIRECT_URI/?code=AUTHORIZATION_CODE&state=STATE
//    
//    /*https://www.linkedin.com/uas/oauth2/accessToken?grant_type=authorization_code
//     &code=AUTHORIZATION_CODE
//     &redirect_uri=YOUR_REDIRECT_URI
//     &client_id=YOUR_API_KEY
//     &client_secret=YOUR_SECRET_KEY*/
//    
//    [self convertURLToCode:url];
//    
    NSString *tokenURL = [NSString stringWithFormat:@"%@&code=%@&redirect_uri=%@&client_id=%@&&client_secret=%@", LINKEDIN_TOKEN_URL, code, LINKEDIN_REDIRECT, kLINKEDIN_API_KEY, kLINKEDIN_SECRET_KEY];
    
//    NSLog(@"Token URL: %@", tokenURL);
    
    return tokenURL;
//
//                          &client_id=%@&scope=%@&state=%@&redirect_uri=%@", LINKEDIN_OAUTH_URL, kLINKEDIN_API_KEY, kLINKEDIN_STATE, LINKEDIN_SCOPE, LINKEDIN_REDIRECT];
//    
//    NSString *code = [self convertURLToCode:url];
//    
//    NSString *post = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&code=%@&redirect_uri=%@", GITHUB_CLIENT_ID, GITHUB_SECRET_ID, code, GITHUB_REDIRECT];
//    
//    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
//    
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setURL:[NSURL URLWithString:GITHUB_POST_URL]];
//    [request setHTTPMethod:@"POST"];
//    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//    [request setHTTPBody:postData];
//    
//    NSURLResponse *response;
//    NSError *error;
//    
//    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    
//    self.accessToken = [self convertResponseIntoToken:responseData];
//    NSLog(@"%@", self.accessToken);
//    
//    [self fetchUsersReposWithAccessToken:self.accessToken];
//    
//    [[NSUserDefaults standardUserDefaults] setObject:self.accessToken forKey:@"accessToken"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    
}

-(NSString *)convertURLToCode:(NSURL *)url
{
    NSString *query = [url query];
    NSArray *components = [query componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"=&"]];
    NSMutableArray *mutCom = [components mutableCopy];
    
    
    if ([mutCom[0]  isEqual: @"code"]) {
        [mutCom removeObjectAtIndex:0];
        authorizationCode = mutCom[0];
        
        return mutCom[0];
//        [self handleCallbackURL:mutCom[0]];
    }
    
    
    
    
    
//    
//    NSLog(@"%@", mutCom[0]);
//    
//    NSString *code = [components lastObject];
    return nil;
}


@end
