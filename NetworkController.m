//
//  NetworkController.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 5/15/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "NetworkController.h"
#import "AppDelegate.h"

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
}


-(NSString *)convertURLToCode:(NSURL *)url
{
    NSString *query = [url query];
    NSArray *components = [query componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"=&"]];
    NSMutableArray *mutComponents = [components mutableCopy];
    
//    NSLog(@"Components: %@", mutComponents);
    
    if ([mutComponents[0]  isEqual: @"code"]) {
        [mutComponents removeObjectAtIndex:0];
        authorizationCode = mutComponents[0];
        
        return mutComponents[0];
    }
    
    return nil;
}

-(void)handleCallbackURL:(NSString *)code
{
    //Generating data for token extension
    NSString *token = [NSString stringWithFormat:@"&code=%@&redirect_uri=%@&client_id=%@&client_secret=%@", code, LINKEDIN_REDIRECT, kLINKEDIN_API_KEY, kLINKEDIN_SECRET_KEY];
    NSLog(@"Token: %@", token);

    //Generating the NSMutableURLRequest with the base LinkedIN URL with token extension in the HTTP Body
    NSURL *url = [NSURL URLWithString:LINKEDIN_TOKEN_URL];
    NSLog(@"URL: %@", url);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
////    [request setHTTPMethod:@"GET"];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[token dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:@"json" forHTTPHeaderField:@"x-li-format"]; // per Linkedin API: https://developer.linkedin.com/documents/api-requests-json
//
//    NSURLResponse *response;
//    NSError *error;
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSString *tokenResponse = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        
        NSLog(@"Token Response: %@", tokenResponse);
        
        NSDictionary *jsonObject=[NSJSONSerialization
                                  JSONObjectWithData:data
                                  options:NSJSONReadingMutableContainers
                                  error:nil];
        self.accessToken = [jsonObject objectForKey:@"access_token"];
        NSLog(@"Access: %@", self.accessToken);

        [[NSUserDefaults standardUserDefaults] setObject:self.accessToken forKey:@"accessToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        [self loadUserData];
    }];
    
    [dataTask resume];
    
//    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    
//   NSString *tokenResponse = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
//    
//    NSLog(@"Token Response: %@", tokenResponse);
//    
//    NSDictionary *jsonObject=[NSJSONSerialization
//                              JSONObjectWithData:responseData
//                              options:NSJSONReadingMutableContainers
//                              error:nil];
//    self.accessToken = [jsonObject objectForKey:@"access_token"];
//    NSLog(@"Access: %@", self.accessToken);
//
//    [[NSUserDefaults standardUserDefaults] setObject:self.accessToken forKey:@"accessToken"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//
//    NSLog(@"Token is currently: %d", [self checkTokenIsCurrent]);
    
}

-(BOOL)checkTokenIsCurrent
{
    NSString *accessURL = [NSString stringWithFormat:@"%@%@&format=json", @"https://api.linkedin.com/v1/people/~:(id,first-name,last-name,industry,headline,location:(name),num-connections,picture-url,email-address,last-modified-timestamp,interests,languages,skills,certifications,three-current-positions,public-profile-url,educations,num-recommenders,recommendations-received)?oauth2_access_token=", [[NSUserDefaults standardUserDefaults] stringForKey:@"accessToken"]];

    NSURL *url = [NSURL URLWithString:accessURL];
    
//    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration ephemeralSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
//    
//    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:[NSURLRequest requestWithURL:url] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        
//    }];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSNumber *status = dictionary[@"status"];
    
    if ([[status stringValue] isEqualToString:@"401"]) {
        return FALSE;
    } else {
        return TRUE;
    }
}

#pragma mark - Load current user data

-(void)loadUserData {
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"accessToken"];
    
    NSLog(@"My access token: %@", accessToken);
    
    //Generating the NSMutableURLRequest with the base LinkedIN URL with token extension in the HTTP Body
    //    NSString *string = [NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~"]
    NSString *accessURL = [NSString stringWithFormat:@"%@%@&format=json", @"https://api.linkedin.com/v1/people/~:(id,first-name,last-name,industry,headline,location:(name),num-connections,picture-url,picture-urls::(original),email-address,last-modified-timestamp,interests,languages,skills,certifications,three-current-positions,public-profile-url,educations,num-recommenders,recommendations-received)?oauth2_access_token=", accessToken];
    
    NSLog(@"%@", accessURL);
    
    NSURL *url = [NSURL URLWithString:accessURL];
    
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url];
    [dataTask setTaskDescription:@"currentUser"];
    
    [dataTask resume];

}

-(void)parseUserData:(NSData *)data {
    
    Worker *newWorker = [NSEntityDescription insertNewObjectForEntityForName:@"Worker" inManagedObjectContext:[CoreDataHelper managedContext]];

    Value *newValue = [NSEntityDescription insertNewObjectForEntityForName:@"Value" inManagedObjectContext:[CoreDataHelper managedContext]];
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                               options:NSJSONReadingMutableLeaves
                                                                 error:nil];
    
    //Saving user info
    newWorker.idNumber = dictionary[@"id"];
    newWorker.firstName = dictionary[@"firstName"];
    newWorker.lastName = dictionary[@"lastName"];
    NSString *fullName = [NSString stringWithFormat:@"%@%@", newWorker.firstName, newWorker.lastName];
    
    newWorker.location = [dictionary valueForKeyPath:@"location.name"];
    newWorker.linkedinURL = dictionary[@"publicProfileUrl"];
    newWorker.emailAddress = dictionary[@"emailAddress"];
    newWorker.numConnections = dictionary[@"numConnections"];
    newWorker.numRecommenders = dictionary[@"numRecommenders"];
    
    //Parsing last updated time (and millisecond conversion)
    NSNumber *date = [dictionary valueForKey:@"lastModifiedTimestamp"];
    float newDate = [date floatValue] / 1000;
    newWorker.lastLinkedinUpdate = [NSDate dateWithTimeIntervalSince1970:newDate];
    
    //Converting NSDate to local time zone
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone localTimeZone];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm";
    //    NSString *timeStamp = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:newDate]];
    
    //Grab Large Image
    newWorker.imageURL = [dictionary valueForKeyPath:@"pictureUrls.values"][0];
    newWorker.imageLocation = [NSString stringWithFormat:@"%@/%@.jpg", [NetworkController documentsDirectoryPath], fullName];
    
    NSURLSession *photoSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    
    //Grab Large Image
    NSURL *largeURL = [NSURL URLWithString:newWorker.imageURL];
    NSURLSessionDownloadTask *downloadLarge = [photoSession downloadTaskWithRequest:[NSURLRequest requestWithURL:largeURL] completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        NSData *largeImageData = [NSData dataWithContentsOfURL:location];
        [largeImageData writeToFile:newWorker.imageLocation atomically:YES];
    }];
    [downloadLarge resume];
    
    //Grab Small Image
    newWorker.smallImageURL = [dictionary valueForKey:@"pictureUrl"];
    newWorker.smallImageLocation = [NSString stringWithFormat:@"%@/%@_small.jpg", [NetworkController documentsDirectoryPath], fullName];
    
    NSURL *smallURL = [NSURL URLWithString:newWorker.smallImageURL];
    NSURLSessionDownloadTask *downloadSmall = [photoSession downloadTaskWithRequest:[NSURLRequest requestWithURL:smallURL] completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        NSData *smallImageData = [NSData dataWithContentsOfURL:location];
        [smallImageData writeToFile:newWorker.smallImageLocation atomically:YES];
    }];
    [downloadSmall resume];
    
    newValue.marketPrice = @1000000;
    newValue.date = [NSDate date];
    
    [newWorker addNewValueObject:newValue];
    
    //Working on parsing current positions
    NSArray *positionArray = [dictionary valueForKeyPath:@"threeCurrentPositions.values"];
    
    for (NSDictionary *positionDictionary in positionArray) {
        Job *newPosition = [NSEntityDescription insertNewObjectForEntityForName:@"Job" inManagedObjectContext:[CoreDataHelper managedContext]];

        //Parse start date
        NSString *startDate = [NSString stringWithFormat:@"%@/%@", [positionDictionary valueForKeyPath:@"startDate.month"], [positionDictionary valueForKeyPath:@"startDate.year"]];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"MM/yyyy"];
        
        NSDate *date = [NSDate date];
        NSTimeInterval employmentLength = [date timeIntervalSinceDate:[formatter dateFromString:startDate]];
        
        //Core Data
        newPosition.isCurrent = @1;
        newPosition.name = [positionDictionary valueForKeyPath:@"company.name"];
        newPosition.industry = [positionDictionary valueForKeyPath:@"company.industry"];
        newPosition.title = [positionDictionary valueForKey:@"title"];
        newPosition.startDate = [formatter dateFromString:startDate];
        //Conversion from seconds to months
        newPosition.monthsInCurrentJob = [NSNumber numberWithFloat:(employmentLength / 60 / 60 / 24 / 365) * 12];
        newPosition.idNumber = [positionDictionary valueForKeyPath:@"company.id"];
  
        [newWorker addJobsObject:newPosition];
    }
    
    //Parsing Educational Institutions
    NSArray *educationArray = [dictionary valueForKeyPath:@"educations.values"];
    
    for (NSDictionary *educationDictionary in educationArray) {
        School *newSchool = [NSEntityDescription insertNewObjectForEntityForName:@"School" inManagedObjectContext:[CoreDataHelper managedContext]];
        
        NSString *startDate = [NSString stringWithFormat:@"%@", [educationDictionary valueForKeyPath:@"startDate.year"]];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy"];
        
        NSString *endDate = [NSString stringWithFormat:@"%@", [educationDictionary valueForKeyPath:@"endDate.year"]];
        
        newSchool.idNumber = [educationDictionary valueForKey:@"id"];
        newSchool.name = [educationDictionary valueForKey:@"schoolName"];
        newSchool.degree = [educationDictionary valueForKey:@"degree"];
        newSchool.fieldOfStudy = [educationDictionary valueForKey:@"fieldOfStudy"];
        newSchool.startYear = [formatter dateFromString:startDate];
        newSchool.endYear = [formatter dateFromString:endDate];
        
        [newWorker addSchoolsObject:newSchool];
    }
    
    //Parsing Languages
    NSArray *languageArray = [dictionary valueForKeyPath:@"languages.values"];
    
    for (NSDictionary *languageDictionary in languageArray) {
        Language *language = [NSEntityDescription insertNewObjectForEntityForName:@"Language" inManagedObjectContext:[CoreDataHelper managedContext]];
        language.idNumber = [languageDictionary valueForKey:@"id"];
        language.name = [languageDictionary valueForKeyPath:@"language.name"];
        [newWorker addLanguagesObject:language];
    }
    
    //Parsing Recommendations
    NSArray *recommendationArray = [dictionary valueForKeyPath:@"recommendationsReceived.values"];

    for (NSDictionary *recommendationDictionary in recommendationArray) {
        Recommendation *recommendation = [NSEntityDescription insertNewObjectForEntityForName:@"Recommendation" inManagedObjectContext:[CoreDataHelper managedContext]];
        
        recommendation.idNumber = [recommendationDictionary valueForKey:@"id"];
        recommendation.text = [recommendationDictionary valueForKey:@"recommendationText"];
        recommendation.code = [recommendationDictionary valueForKeyPath:@"recommendationType.code"];
        recommendation.recommenderID = [recommendationDictionary valueForKeyPath:@"recommender.id"];
        recommendation.firstName = [recommendationDictionary valueForKeyPath:@"recommender.firstName"];
        recommendation.lastName = [recommendationDictionary valueForKeyPath:@"recommender.lastName"];

        [newWorker addNewRecommendationObject:recommendation];
    }
    
//    [newWorker setValue:gamer.headline forKey:@"headline"];
//    [newWorker setValue:gamer.industry forKey:@"industry"];
    
    NSLog(@"User: %@ %@", newWorker.firstName, newWorker.lastName);
    
    [CoreDataHelper saveContext];
    [self.delegate setGamerData];
    //Parsing Connection info
//    [self grabUserConnections:newWorker inContext:[CoreDataHelper managedContext] atRange:0];
}

+(void)grabUserConnections:(Worker *)worker inContext:(NSManagedObjectContext *)context atRange:(NSInteger)range {
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"accessToken"];
    
    NSString *connectionAccess = [NSString stringWithFormat:@"%@%@&format=json&start=%ld&count=50", @"https://api.linkedin.com/v1/people/~/connections:(id,first-name,last-name,num-connections,num-connections-capped,positions,public-profile-url,headline,industry,location,pictureUrl,picture-urls::(original))?oauth2_access_token=", accessToken, range];
    
    NSURL *connectionURL = [NSURL URLWithString:connectionAccess];
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    
//    [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:[NSURLRequest requestWithURL:connectionURL]completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *connectionDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                             options:NSJSONReadingMutableLeaves
                                                                               error:nil];
        NSArray *connectionArray = connectionDictionary[@"values"];
        //    NSLog(@"Connections: %lu", (unsigned long)connectionArray.count);
        
        for (NSDictionary *connection in connectionArray) {
            if ([connection[@"firstName"] isEqualToString:@"private"]) {
                //Private Users - contain no info
            } else {
                //Add to Core Data
                Connection *newConnection = [NSEntityDescription insertNewObjectForEntityForName:@"Connection" inManagedObjectContext:[CoreDataHelper managedContext]];
                
                newConnection.idNumber = connection[@"id"];

                newConnection.firstName = connection[@"firstName"];
                newConnection.lastName = connection[@"lastName"];
                newConnection.location = [connection valueForKeyPath:@"location.name"];
                
                NSString *fullName = [NSString stringWithFormat:@"%@%@", newConnection.firstName, newConnection.lastName];
                newConnection.imageURL = [connection valueForKeyPath:@"pictureUrls.values"][0];
                newConnection.imageLocation = [NSString stringWithFormat:@"%@/%@.jpg", [NetworkController documentsDirectoryPath], fullName];
                newConnection.smallImageURL = [connection valueForKey:@"pictureUrl"];
                newConnection.smallImageLocation = [NSString stringWithFormat:@"%@/%@_small.jpg", [NetworkController documentsDirectoryPath], fullName];
                
                newConnection.invitationSent = @0;
                newConnection.headline = connection[@"headline"];
                newConnection.industry = connection[@"industry"];
                newConnection.numConnections = connection[@"numConnections"];
                newConnection.linkedinURL = connection[@"publicProfileUrl"];
                
                //Add Insight
                Insight *model = [NSEntityDescription insertNewObjectForEntityForName:@"Insight" inManagedObjectContext:[CoreDataHelper managedContext]];

                model.firstName = @"Johnny";
                model.lastName = @"Appleseed";
                model.position = @"Expert";
                model.location = @"Cupertino, CA";
                model.comments = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
                model.company = @"Apple, Inc.";
                
                [newConnection addNewInsightObject:model];
                
                NSArray *connectionPositionArray = [connection valueForKeyPath:@"positions.values"];
                
                for (NSDictionary *positionDictionary in connectionPositionArray) {
                    Job *newJob = [NSEntityDescription insertNewObjectForEntityForName:@"Job" inManagedObjectContext:[CoreDataHelper managedContext]];
                    
                    NSDictionary *company = positionDictionary[@"company"];
                    
                    //Parse start date
                    NSString *startDate = [NSString stringWithFormat:@"%@/%@", [positionDictionary valueForKeyPath:@"startDate.month"], [positionDictionary valueForKeyPath:@"startDate.year"]];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                    [formatter setDateFormat:@"MM/yyyy"];
                    
                    NSDate *date = [NSDate date];
                    NSTimeInterval employmentLength = [date timeIntervalSinceDate:[formatter dateFromString:startDate]];
                    
                    //Core Data
                    newJob.idNumber = [company objectForKey:@"id"];
                    newJob.name = [company objectForKey:@"name"];
                    newJob.industry = [company objectForKey:@"industry"];
                    newJob.title = [positionDictionary valueForKey:@"title"];
                    newJob.startDate = [formatter dateFromString:startDate];
                    
                    //Conversion from seconds to months
                    newJob.monthsInCurrentJob = [NSNumber numberWithFloat:(employmentLength / 60 / 60 / 24 / 365) * 12];
                    
                    [newConnection addJobsObject:newJob];
                }
                
                Value *newValue = [NSEntityDescription insertNewObjectForEntityForName:@"Value" inManagedObjectContext:[CoreDataHelper managedContext]];
                
                newValue.marketPrice = @1000000;
                newValue.date = [NSDate date];
                
                [newConnection addNewValueObject:newValue];
                
                [worker addConnectionsObject:newConnection];
            }
        }
        
        [CoreDataHelper saveContext];
//        [self.delegate setGamerData];
    }];
    
    [dataTask resume];
}

#pragma mark - Documents Path

+(NSString *)documentsDirectoryPath
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

-(void)shareOnLinkedin:(id)sender {
    
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    NSString *urlString = [NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~/shares?oauth2_access_token=%@", accessToken];
    
    if ([sender isKindOfClass:[Connection class]]) {
//        Connection *connection = (Connection *)sender;
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    
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
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:shareData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *stringResponse = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        
        NSLog(@"%@", stringResponse);

    }];
    
//    NSURLResponse *response;
//    NSError *error;
//    
//    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    NSString *stringResponse = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
//    
//    NSLog(@"%@", stringResponse);
    
    [uploadTask resume];
    
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

#pragma mark - Textalytics

-(void)checkProfileText:(NSString *)string {
    
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    NSString *searchString = [NSString stringWithFormat:@"tt=ecr&dic=chetsdpCA&key=1c03ecaeb9c146a07056c4049064cb3a&of=json&lang=en&txt=%@&txtf=plain&url=&_tte=e&_ttc=c&_ttr=r&dm=4&cont=&ud=", string];
    
    NSData *data = [searchString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://textalytics.com/core/topics-1.2"]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    
    NSURLResponse *response;
    NSError *error;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
    
//    NSArray *entityArray = [dictionary objectForKey:@"entity_list"];
    NSArray *conceptArray = [dictionary objectForKey:@"concept_list"];
    
    NSLog(@"%@", conceptArray);
    
    /*    NSURL *url = [NSURL URLWithString:LINKEDIN_TOKEN_URL];
     NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
     [request setHTTPMethod:@"POST"];
     [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
     [request setHTTPBody:[token dataUsingEncoding:NSUTF8StringEncoding]];
     [request setValue:@"json" forHTTPHeaderField:@"x-li-format"]; // per Linkedin API: https://developer.linkedin.com/documents/api-requests-json*/
    
//    NSDictionary *jobDictionary = @{@"SOFTWARE ENGINEER":@[@"$75,411",@"$27,877", @"37.0%"],
//                                    @"SOFTWARE DEVELOPER":@[@"$72,510",@"$10,980", @"15.1%"],
//                                    @"BUSINESS ANALYST":@[@"$65,841",@"$5,482",@"8.3%"],
//                                    @"SENIOR CONSULTANT":@[@"$95,902",@"$4,761",@"5.0%"],
//                                    @"CONSULTANT":@[@"$77,411",@"$6,713",@"8.7%"],
//                                    @"SENIOR SOFTWARE ENGINEER":@[@"$90,055",@"$20,534",@"22.8%"],
//                                    @"PROJECT MANAGER":@[@"$78,305",@"$12,875",@"16.4%"],
//                                    @"DATABASE ADMINISTRATOR":@[@"$66,410",@"$4,013",@"6.0%"],
//                                    @"ASSISTANT PROFESSOR":@[@"$98,770",@"-$5,693",@"-5.8%"],
//                                    @"WEB DEVELOPER":@[@"$64,494",@"$7,376",@"11.4%"],
//                                    @"MECHANICAL ENGINEER":@[@"$68,844",@"$9,663",@"14.0%"],
//                                    @"ACCOUNTANT":@[@"$50,282",@"$3,506",@"7.0%"],
//                                    @"FINANCIAL ANALYST":@[@"$64,146",@"$9,733",@"15.2%"],
//                                    @"POSTDOCTORAL FELLOW":@[@"$45,806",@"$3,505",@"7.7%"],
//                                    @"INDUSTRIAL DESIGNER":@[@"$54,071",@"$19,002",@"35.1%"],
//                                    @"MARKET RESEARCH ANALYST":@[@"$48,118",@"$4,314",@"9.0%"],
//                                    @"PHYSICIAN":@[@"$157,355",@"$38,693",@"24.6%"],  // @[@157355, @38693, @24.6],
//                                    @"PRODUCT MANAGER":@[@"$95,024",@"$17,898",@"18.8%"],
//                                    @"OTHER":@[@"$50,000",@"$7,122",@"14.2%"]
//                                    };
    
}

-(void)listDictionaries {
    NSURLSessionConfiguration *defaultSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultSessionConfiguration];
    
    __block NSArray *customDictionaries;
    __block NSDictionary *customDictionary;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://textalytics.com/api/sempub/1.0/manage/dictionary_list/?key=b8d169500ad3ded96d69054182f829cd"]];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        customDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSArray *array = [customDictionary valueForKey:@"dictionary_list"];
        NSLog(@"Dictionary Count: %@", [array[0] valueForKey:@"description"]);
        customDictionaries = array;
        
    }];
    
    
    [dataTask resume];
    
}

-(void)readDictionaryWithName:(NSString *)name {
    NSURLSessionConfiguration *defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultConfiguration];
    
    NSString *urlString = [NSString stringWithFormat:@"https://textalytics.com/api/sempub/1.0/manage/dictionary_list/%@/?key=b8d169500ad3ded96d69054182f829cd", name];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSString *stringResponse = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        
        NSLog(@"Read: %@", stringResponse);
        
    }];
    
    [dataTask resume];
//    NSURLResponse *response;
//    NSError *error;
//    
//    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    NSString *stringResponse = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
//    
//    NSLog(@"%@", stringResponse);
    
}

#pragma mark - NSURLSession Delegate Methods

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    
    if ([dataTask.taskDescription isEqualToString:@"currentUser"]) {
        [self parseUserData:data];
//        [self.delegate setGamerData];
        
    } else {
        NSLog(@"It is not");
    }
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask {
    
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
    
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
}

@end
