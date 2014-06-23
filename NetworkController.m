//
//  NetworkController.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 5/15/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "NetworkController.h"
#import "AppDelegate.h"
#import "Gamer.h"

#define LINKEDIN_OAUTH_URL @"https://www.linkedin.com/uas/oauth2/authorization?response_type=code"
#define LINKEDIN_TOKEN_URL @"https://www.linkedin.com/uas/oauth2/accessToken?grant_type=authorization_code"

#define LINKEDIN_REDIRECT @"http://comingsoon.blankchecklabs.com"

#define LINKEDIN_SCOPE @"r_fullprofile%20r_emailaddress%20r_network%20r_contactinfo%20w_messages%20rw_nus"

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

#pragma mark - Load current user data

-(Gamer *)loadCurrentUserData
{
    Gamer *gamer = [Gamer new];
    
//    [operationQueue addOperationWithBlock:^{
    
    
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"accessToken"];
    //Generating the NSMutableURLRequest with the base LinkedIN URL with token extension in the HTTP Body
    //    NSString *string = [NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~"]
    NSString *accessURL = [NSString stringWithFormat:@"%@%@&format=json", @"https://api.linkedin.com/v1/people/~:(id,first-name,last-name,industry,headline,location:(name),num-connections,picture-urls::(original),email-address,last-modified-timestamp,interests,languages,skills,certifications,three-current-positions,public-profile-url,educations,num-recommenders,recommendations-received)?oauth2_access_token=", accessToken];
    
    /*NSURL *url = [NSURL URLWithString:@"https://api.linkedin.com/v1/people/~:(id,first-name,last-name,industry,headline,location:(name),num-connections,picture-url,email-address,last-modified-timestamp,interests,languages,skills,certifications,three-current-positions,public-profile-url,educations,num-recommenders,recommendations-received)?oauth2_access_token=AQWlBgoqxdW9OLFOg1UUEGFt_Re-vnQLw7F9lTHXM6QzPBiT0iWzXOQQHP49hfmfm21N2n7LGhAnDRB3tsYdnfoQK9sG8KMDjrVVeTp5Psld5VAkE0ACHcd0MDrdT0_VOfVXLbDIc4wfqL3tlrnvGuqHcs2TeRwxTL4nzL_oVTM8e9NVeE8&format=json"];*/
    
    NSLog(@"%@", accessURL);
    
    NSURL *url = [NSURL URLWithString:accessURL];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                               options:NSJSONReadingMutableLeaves
                                                                 error:nil];
    
    gamer.firstName = dictionary[@"firstName"];
    gamer.lastName = dictionary[@"lastName"];
    gamer.fullName = [NSString stringWithFormat:@"%@ %@", gamer.firstName, gamer.lastName];
    gamer.gamerID = dictionary[@"id"];
    gamer.gamerEmail = dictionary[@"emailAddress"];
    gamer.location = [dictionary valueForKeyPath:@"location.name"];
    gamer.linkedinURL = dictionary[@"publicProfileUrl"];
    gamer.numConnections = dictionary[@"numConnections"];
    gamer.numRecommenders = dictionary[@"numRecommenders"];
    
    //Working on parsing current positions
    NSMutableArray *tempArray = [NSMutableArray new];
    NSArray *positionArray = [dictionary valueForKeyPath:@"threeCurrentPositions.values"];
    
    for (NSDictionary *positionDictionary in positionArray) {
        Position *position = [Position new];
        position.isCurrent = TRUE;
        position.companyName = [positionDictionary valueForKeyPath:@"company.name"];
        position.idNumber = [positionDictionary valueForKeyPath:@"company.id"];
        position.industry = [positionDictionary valueForKeyPath:@"company.industry"];
        position.title = [positionDictionary valueForKey:@"title"];
        
        //Parse start date
        NSString *startDate = [NSString stringWithFormat:@"%@/%@", [positionDictionary valueForKeyPath:@"startDate.month"], [positionDictionary valueForKeyPath:@"startDate.year"]];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"MM/yyyy"];
        position.startDate = [formatter dateFromString:startDate];
        
        NSDate *date = [NSDate date];
        NSTimeInterval employmentLength = [date timeIntervalSinceDate:position.startDate];
        //Conversion from seconds to months
        position.monthsInCurrentJob = (employmentLength / 60 / 60 / 24 / 365) * 12;
        
        [tempArray addObject:position];
    }
    
    gamer.currentPositionArray = tempArray;
    
    //    NSLog(@"%@", positionArray[0]);
    
    //Parsing skills
    gamer.gamerSkills = [NSMutableArray new];
    NSArray *skillsArray = [dictionary valueForKeyPath:@"skills.values"];
    
    for (NSDictionary *skillsDictionary in skillsArray) {
        NSString *skill = [skillsDictionary valueForKeyPath:@"skill.name"];
        [gamer.gamerSkills addObject:skill];
    }
    
    
    //Parsing Educational Institutions
    gamer.educationArray = [NSMutableArray new];
    
    NSArray *educationArray = [dictionary valueForKeyPath:@"educations.values"];
    
    for (NSDictionary *educationDictionary in educationArray) {
        Education *institution = [Education new];
        institution.schoolID = [educationDictionary valueForKey:@"id"];
        institution.schoolName = [educationDictionary valueForKey:@"schoolName"];
        institution.degree = [educationDictionary valueForKey:@"degree"];
        institution.fieldOfStudy = [educationDictionary valueForKey:@"fieldOfStudy"];
        
        NSString *startDate = [NSString stringWithFormat:@"%@", [educationDictionary valueForKeyPath:@"startDate.year"]];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy"];
        institution.startYear = [formatter dateFromString:startDate];
        
        NSString *endDate = [NSString stringWithFormat:@"%@", [educationDictionary valueForKeyPath:@"endDate.year"]];
        institution.endYear = [formatter dateFromString:endDate];
        
        [gamer.educationArray addObject:institution];
        
    }
    
    //Parsing Languages
    gamer.GamerLanguages = [NSMutableArray new];
    
    NSArray *languageArray = [dictionary valueForKeyPath:@"languages.values"];
    
    for (NSDictionary *languageDictionary in languageArray) {
        Language *language = [Language new];
        language.languageID = [languageDictionary valueForKey:@"id"];
        language.languageName = [languageDictionary valueForKeyPath:@"language.name"];
        
        [gamer.gamerLanguages addObject:language];
    }
    
    //Parsing Recommendations
    gamer.gamerRecommendations = [NSMutableArray new];
    
    NSArray *recommendationArray = [dictionary valueForKeyPath:@"recommendationsReceived.values"];
    
    for (NSDictionary *recommendationDictionary in recommendationArray) {
        Recommendation *recommendation = [Recommendation new];
        recommendation.recommendationID = [recommendationDictionary valueForKey:@"id"];
        recommendation.recommendationText = [recommendationDictionary valueForKey:@"recommendationText"];
        recommendation.recommendationType = [recommendationDictionary valueForKeyPath:@"recommendationType.code"];
        recommendation.recommenderID = [recommendationDictionary valueForKeyPath:@"recommender.id"];
        recommendation.firstName = [recommendationDictionary valueForKeyPath:@"recommender.firstName"];
        recommendation.lastName = [recommendationDictionary valueForKeyPath:@"recommender.lastName"];
        
        [gamer.gamerRecommendations addObject:recommendation];
    }
    
    //Parsing last updated time (and millisecond conversion)
    NSNumber *date = [dictionary valueForKey:@"lastModifiedTimestamp"];
    float newDate = [date floatValue] / 1000;
    gamer.lastLinkedinUpdate = [NSDate dateWithTimeIntervalSince1970:newDate];
    
    
    //Grabbing the image URL
    gamer.imageURL = [NSURL URLWithString:[dictionary valueForKeyPath:@"pictureUrls.values"][0]];
    
    NSString *fullName = [NSString stringWithFormat:@"%@%@", gamer.firstName, gamer.lastName];
    gamer.imageLocalLocation = [NSString stringWithFormat:@"%@/%@.jpg", [self documentsDirectoryPath], fullName];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:gamer.imageLocalLocation];
    
    if (!fileExists) {
        NSData *profilePicData = [NSData dataWithContentsOfURL:gamer.imageURL];
        [profilePicData writeToFile:gamer.imageLocalLocation atomically:YES];
        gamer.profileImage = [UIImage imageWithData:profilePicData];
    } else {
        gamer.profileImage = [UIImage imageWithData:[NSData dataWithContentsOfMappedFile:gamer.imageLocalLocation]];
    }
    
    
    //Parsing Connection info
    gamer.connectionIDArray = [NSMutableArray new];
    
    NSString *connectionAccess = [NSString stringWithFormat:@"%@%@&format=json", @"https://api.linkedin.com/v1/people/~/connections:(id,first-name,last-name,num-connections,num-connections-capped,positions,public-profile-url,headline,industry,location,picture-urls::(original))?oauth2_access_token=", accessToken];
    
    NSURL *connectionURL = [NSURL URLWithString:connectionAccess];
    
    /*NSURL *connectionURL = [NSURL URLWithString:@"https://api.linkedin.com/v1/people/~/connections?oauth2_access_token=AQWlBgoqxdW9OLFOg1UUEGFt_Re-vnQLw7F9lTHXM6QzPBiT0iWzXOQQHP49hfmfm21N2n7LGhAnDRB3tsYdnfoQK9sG8KMDjrVVeTp5Psld5VAkE0ACHcd0MDrdT0_VOfVXLbDIc4wfqL3tlrnvGuqHcs2TeRwxTL4nzL_oVTM8e9NVeE8&format=json"];*/
    
    NSData *connectionData = [NSData dataWithContentsOfURL:connectionURL];
    NSDictionary *connectionDictionary = [NSJSONSerialization JSONObjectWithData:connectionData
                                                                         options:NSJSONReadingMutableLeaves
                                                                           error:nil];
    NSArray *connectionArray = connectionDictionary[@"values"];
    
    for (NSDictionary *connection in connectionArray) {
        Gamer *gamerConnection = [Gamer new];
        gamerConnection.gamerID = connection[@"id"];
        gamerConnection.firstName = connection[@"firstName"];
        gamerConnection.lastName = connection[@"lastName"];
        gamerConnection.fullName = [NSString stringWithFormat:@"%@ %@", gamerConnection.firstName, gamerConnection.lastName];
        
        //Add a base value
        gamerConnection.valueArray = [NSMutableArray new];
        [gamerConnection.valueArray addObject:@"1,000,000"];
        
        gamerConnection.headline = connection[@"headline"];
        gamerConnection.industry = connection[@"industry"];
        gamerConnection.numConnections = connection[@"numConnections"];
        gamerConnection.imageURL = [NSURL URLWithString:[connection valueForKeyPath:@"pictureUrls.values"][0]];
        gamerConnection.location = [connection valueForKeyPath:@"location.name"];
        gamerConnection.linkedinURL = [NSURL URLWithString:connection[@"publicProfileUrl"]];
        
        NSMutableArray *tempConnectionArray = [NSMutableArray new];
        NSArray *connectionPositionArray = [connection valueForKeyPath:@"positions.values"];
        //        NSDictionary *connectDictoinary = [dictionary valueForKeyPath:@"positions"];
        
        for (NSDictionary *positionDictionary in connectionPositionArray) {
            Position *position = [Position new];
            
            
            position.isCurrent = [positionDictionary[@"isCurrent"] integerValue];
            
            NSDictionary *company = positionDictionary[@"company"];
            
            position.idNumber = [company objectForKey:@"id"];
            position.companyName = [company objectForKey:@"name"];
            position.industry = [company objectForKey:@"industry"];
            
            position.title = [positionDictionary valueForKey:@"title"];
            
            //Parse start date
            NSString *startDate = [NSString stringWithFormat:@"%@/%@", [positionDictionary valueForKeyPath:@"startDate.month"], [positionDictionary valueForKeyPath:@"startDate.year"]];
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"MM/yyyy"];
            position.startDate = [formatter dateFromString:startDate];
            
            NSDate *date = [NSDate date];
            NSTimeInterval employmentLength = [date timeIntervalSinceDate:position.startDate];
            //Conversion from seconds to months
            position.monthsInCurrentJob = (employmentLength / 60 / 60 / 24 / 365) * 12;
            
            
            [tempConnectionArray addObject:position];
            
        }
        
        gamerConnection.currentPositionArray = tempConnectionArray;
        
        if ([gamerConnection.firstName isEqualToString:@"private"]) {
            NSLog(@"Private User");
        } else {
            [gamer.connectionIDArray addObject:gamerConnection];
        }
    }
    
    NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:nameDescriptor];
    NSArray *sortedArray = [gamer.connectionIDArray sortedArrayUsingDescriptors:sortDescriptors];
        
//  NSArray *sortedArray = [NSArray arrayWithArray:[gamer.connectionIDArray sortUsingDescriptors:@[sortDescriptor]]];
    
    gamer.connectionIDArray = [sortedArray mutableCopy];
            
    return gamer;
}


- (NSString *)documentsDirectoryPath
{
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    return [documentsURL path];
}

-(void)sendInvitationToUserID:(NSString *)userID
{
    
    NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    NSString *url = [NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~/mailbox?oauth2_access_token=%@", string];
    
    NSDictionary *recipientPathDictionary = @{@"_path":[NSString stringWithFormat:@"/people/%@", userID]};
    NSDictionary *recipientDictionary = @{@"person": recipientPathDictionary};
    
    NSArray *array = [NSArray arrayWithObjects:recipientDictionary, nil];
    
    NSDictionary *recipients = @{@"values":array};
    
    NSURL *linkURL = [NSURL URLWithString:@"http://comingsoon.blankchecklabs.com/"];
    
    NSString *body = [NSString stringWithFormat:@"Join me on the app Blank Check Labs. \n%@", linkURL];
    
    NSDictionary *messageDictionary = @{@"subject":@"Invitation to join Blank Check Labs",
                                        @"body":body,
                                        @"recipients":recipients};
    
    

    
    NSError *JSONError;
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:messageDictionary options:NSJSONWritingPrettyPrinted error:&JSONError];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPBody:postData];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"json" forHTTPHeaderField:@"x-li-format"];
    
    NSURLResponse *response;
    NSError *error;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *stringResponse = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
    
    NSLog(@"%@", stringResponse);
}

-(void)shareOnLinkedin:(Gamer *)gamer {
    
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    NSString *urlString = [NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~/shares?oauth2_access_token=%@", accessToken];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    
    NSDictionary *contentDictionary = @{@"title":@"Utilize Blank Check Labs to see my value...and YOURS!",
                                        @"description":@"New app utilizing Linkedin's API to determine job value",
                                        @"submitted-url":@"http://www.BlankCheckLabs.com"};
    
    NSDictionary *visibilityDictionary = @{@"code":@"anyone"};
                                        
    
    NSDictionary *shareDictionary = @{@"comment":@"Check out my value!",
                                      @"content":contentDictionary,
                                      @"visibility":visibilityDictionary};
    
    NSError *jsonError;
    
    NSData *shareData = [NSJSONSerialization dataWithJSONObject:shareDictionary options:NSJSONWritingPrettyPrinted error:&jsonError];
    
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request setURL:url];
    [request setHTTPBody:shareData];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"json" forHTTPHeaderField:@"x-li-format"];
    
    NSURLResponse *response;
    NSError *error;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *stringResponse = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
    
    NSLog(@"%@", stringResponse);
    
}

-(NSArray *)commonConnectionsWithUser:(NSString *)userID
{
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.linkedin.com/v1/people/id=%@:(relation-to-viewer:(related-connections:(id,first-name,last-name,positions,location:(name),industry,num-connections)))?oauth2_access_token=AQW4krK0LXeaRN7-hFLju5dDQB-gFvnt8R65Mqi-2qBoh17xSpHR_xT7e-KoEG94hQMVgMuanKCj4XL27ApcXIJO85S6QYuFqPjCJSTkaNsQ9KqZEXh-InhN-yPTt8UhMzTY4kPMaJKqGW7zPlYnERVbAi-QOLSIcHMavjglQkVKoICcPrA&format=json", userID];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSDictionary *commonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    NSArray *array = [commonDictionary valueForKeyPath:@"relationToViewer.relatedConnections.values"];
    
    return array;
}
//
@end
