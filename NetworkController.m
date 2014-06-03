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
    
    NSLog(@"%@", authorizationURL);
    
    return authorizationURL;
    
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authorizationURL]];
    
//    return authorizationURL;
                       //LINKED_CLIENT_ID, GITHUB_REDIRECT, @"user,repo"];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:myURL]];
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

-(void)handleCallbackURL:(NSString *)code
{

    //
    //    [self convertURLToCode:url];
    //
//    NSString *tokenURL = [NSString stringWithFormat:@"%@&code=%@&redirect_uri=%@&client_id=%@&client_secret=%@", LINKEDIN_TOKEN_URL, code, LINKEDIN_REDIRECT, kLINKEDIN_API_KEY, kLINKEDIN_SECRET_KEY];
    
    
    //Generating data for token extension
    NSString *token = [NSString stringWithFormat:@"&code=%@&redirect_uri=%@&client_id=%@&client_secret=%@", code, LINKEDIN_REDIRECT, kLINKEDIN_API_KEY, kLINKEDIN_SECRET_KEY];
    NSLog(@"Token: %@", token);

    //Generating the NSMutableURLRequest with the base LinkedIN URL with token extension in the HTTP Body
    NSURL *url = [NSURL URLWithString:LINKEDIN_TOKEN_URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[token dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:@"json" forHTTPHeaderField:@"x-li-format"]; // per Linkedin API: https://developer.linkedin.com/documents/api-requests-json
    
    //    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    //    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //    [request setHTTPBody:postData];
    //
    NSURLResponse *response;
    NSError *error;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    //    NSString *tokenResponse = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
    
    NSDictionary *jsonObject=[NSJSONSerialization
                              JSONObjectWithData:responseData
                              options:NSJSONReadingMutableLeaves
                              error:nil];
    //    NSLog(@"jsonObject is %@",jsonObject);
    self.accessToken = [jsonObject objectForKey:@"access_token"];
    NSLog(@"Access: %@", self.accessToken);
    
    
    [[NSUserDefaults standardUserDefaults] setObject:self.accessToken forKey:@"accessToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(BOOL)checkTokenIsCurrent
{
//    NSLog(@"Token: %@",[[NSUserDefaults standardUserDefaults] stringForKey:@"accessToken"]);
    
    NSString *accessURL = [NSString stringWithFormat:@"%@%@&format=json", @"https://api.linkedin.com/v1/people/~:(id,first-name,last-name,industry,headline,location:(name),num-connections,picture-url,email-address,last-modified-timestamp,interests,languages,skills,certifications,three-current-positions,public-profile-url,educations,num-recommenders,recommendations-received)?oauth2_access_token=", [[NSUserDefaults standardUserDefaults] stringForKey:@"accessToken"]];

    NSURL *url = [NSURL URLWithString:accessURL];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    NSNumber *status = dictionary[@"status"];
    

    
    if ([[status stringValue] isEqualToString:@"401"]) {
        return FALSE;
    } else {
        return TRUE;

    }
 
    
}


@end
