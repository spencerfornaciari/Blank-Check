//
//  NetworkController.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 5/15/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "NetworkController.h"
#import "AppDelegate.h"
#import "ValueController.h"

#define LINKEDIN_OAUTH_URL @"https://www.linkedin.com/uas/oauth2/authorization?response_type=code"
#define LINKEDIN_TOKEN_URL @"https://www.linkedin.com/uas/oauth2/accessToken?grant_type=authorization_code"
#define LINKEDIN_REDIRECT @"http://comingsoon.blankchecklabs.com"
#define LINKEDIN_SCOPE @"r_fullprofile%20r_emailaddress%20r_network%20r_contactinfo%20w_messages%20rw_nus"

@implementation NetworkController{
    NSString *authorizationCode;
}

//Create Network Controller singleton
+ (NetworkController *)sharedController
{
    static dispatch_once_t pred;
    static NetworkController *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[NetworkController alloc] init];
    });
    return shared;
}

//Request authorization code from LinkedIn
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

//Convert response URL from LinkedIn into authorization code
-(NSString *)convertURLToCode:(NSURL *)url
{
    NSString *query = [url query];
    NSArray *components = [query componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"=&"]];
    NSMutableArray *mutComponents = [components mutableCopy];
    
    if ([mutComponents[0]  isEqual: @"code"]) {
        [mutComponents removeObjectAtIndex:0];
        authorizationCode = mutComponents[0];
        
        return mutComponents[0];
    }
    
    return nil;
}

//Respond to the URL LinkedIn returned to request an authorization token
-(void)handleCallbackURL:(NSString *)code
{
    //Generating data for token extension
    NSString *token = [NSString stringWithFormat:@"&code=%@&redirect_uri=%@&client_id=%@&client_secret=%@", code, LINKEDIN_REDIRECT, kLINKEDIN_API_KEY, kLINKEDIN_SECRET_KEY];
    NSLog(@"Token: %@", token);
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", LINKEDIN_TOKEN_URL, token];

    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"URL: %@", url);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"json" forHTTPHeaderField:@"x-li-format"]; // per Linkedin API: https://developer.linkedin.com/documents/api-requests-json
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *jsonObject=[NSJSONSerialization
                                  JSONObjectWithData:data
                                  options:NSJSONReadingMutableContainers
                                  error:nil];
        
        NSLog(@"Token Response: %@", jsonObject);

        self.accessToken = [jsonObject objectForKey:@"access_token"];
        
        [[NSUserDefaults standardUserDefaults] setObject:self.accessToken forKey:@"accessToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        @try {
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"dataExists"]) {
                
            } else {
                [self loadUserData];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Exception");
            
            while (![self checkTokenIsCurrent]) {
                NSLog(@"Not ready to grab data");
            }
            
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"dataExists"]) {
                
            } else {
                [self loadUserData];
            }
        }
        @finally {
            NSLog(@"Testing");
        }
        
    }];
    
    [dataTask resume];
    
}

//Checks to see if the LinkedIn token that has been received is still current
-(BOOL)checkTokenIsCurrent
{
    
    NSString *accessURL = [NSString stringWithFormat:@"%@%@&format=json", @"https://api.linkedin.com/v1/people/~:(id,first-name,last-name,industry,headline,location:(name),num-connections,picture-url,email-address,last-modified-timestamp,interests,languages,skills,certifications,three-current-positions,public-profile-url,educations,num-recommenders,recommendations-received)?oauth2_access_token=", [[NSUserDefaults standardUserDefaults] stringForKey:@"accessToken"]];

    NSURL *url = [NSURL URLWithString:accessURL];
    
//    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration ephemeralSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
//    
//    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:[NSURLRequest requestWithURL:url] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        
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

//Checks to see if the LinkedIn token is still current, but returns a callback
-(void)checkTokenIsCurrentWithCallback:(void (^)(BOOL finished))completion
{
    NSString *accessURL = [NSString stringWithFormat:@"%@%@&format=json", @"https://api.linkedin.com/v1/people/~:(id,first-name,last-name,industry,headline,location:(name),num-connections,picture-url,email-address,last-modified-timestamp,interests,languages,skills,certifications,three-current-positions,public-profile-url,educations,num-recommenders,recommendations-received)?oauth2_access_token=", [[NSUserDefaults standardUserDefaults] stringForKey:@"accessToken"]];
    
    NSURL *url = [NSURL URLWithString:accessURL];
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];

    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:[NSURLRequest requestWithURL:url] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSNumber *status = dictionary[@"status"];
        
        if ([[status stringValue] isEqualToString:@"401"]) {
            completion(FALSE);
        } else {
            completion(TRUE);
        }
    }];
    
    [dataTask resume];

}

#pragma mark - Load current user data

//After O-Auth Token is received this grabs the data from the user's profile
-(void)loadUserData {
//    NSString *accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"accessToken"];
//    
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"]) {
//        self.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
//    } else {
//        
//    }
    
    NSLog(@"My access token: %@", self.accessToken);
    
    //Generating the NSMutableURLRequest with the base LinkedIN URL with token extension in the HTTP Body
    //    NSString *string = [NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~"]
    NSString *accessURL = [NSString stringWithFormat:@"%@%@&format=json", @"https://api.linkedin.com/v1/people/~:(id,first-name,last-name,industry,headline,location:(name),num-connections,picture-url,picture-urls::(original),email-address,last-modified-timestamp,interests,languages,skills,certifications,three-current-positions,public-profile-url,educations,num-recommenders,recommendations-received)?oauth2_access_token=", self.accessToken];
    
    NSLog(@"%@", accessURL);
    
    NSURL *url = [NSURL URLWithString:accessURL];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    
//    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        [self parseUserData:data];
//        [self.delegate setGamerData];
//    }];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url];
    [dataTask setTaskDescription:@"currentUser"];
    
    [dataTask resume];

}

//Parses the data from the user's profile and enters it into the SQL-lite database
-(void)parseUserData:(NSData *)data {
    
    Worker *newWorker = [NSEntityDescription insertNewObjectForEntityForName:@"Worker" inManagedObjectContext:[CoreDataHelper managedContext]];
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                               options:NSJSONReadingMutableLeaves
                                                                 error:nil];
    
    
    
    NSLog(@"Name: %@", dictionary[@"firstName"]);
    
    //Saving user info
    newWorker.idNumber = dictionary[@"id"];
    newWorker.firstName = dictionary[@"firstName"];
    
    NSLog(@"Name %@", dictionary[@"firstName"]);
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
    
    
    NSArray *jobValueArray = [ValueController jobValue:[ValueController careerSearch:newWorker]];

    for (NSDictionary *dict in [ValueController generateBackValues:jobValueArray[0]]) {
        
        Value *newValue = [NSEntityDescription insertNewObjectForEntityForName:@"Value" inManagedObjectContext:[CoreDataHelper managedContext]];
        newValue.marketPrice = [dict objectForKey:@"value"];
        newValue.date = [NSDate date];
        [newWorker addNewValueObject:newValue];
    }
    
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
  
        [newWorker addNewJobObject:newPosition];
    }
    
    if (newWorker.jobs.count > 0) {
        NSArray *array = [ValueController jobValue:[ValueController careerSearch:newWorker]];
        
        for (NSDictionary *dict in [ValueController generateBackValues:array[0]]) {
            Value *newValue = [NSEntityDescription insertNewObjectForEntityForName:@"Value" inManagedObjectContext:[CoreDataHelper managedContext]];
            newValue.marketPrice = [dict objectForKey:@"value"];
            newValue.date = [NSDate date];
            [newWorker addNewValueObject:newValue];
        }
    } else {
        for (int i = 0; i < 6; i++) {
            Value *newValue = [NSEntityDescription insertNewObjectForEntityForName:@"Value" inManagedObjectContext:[CoreDataHelper managedContext]];
            newValue.marketPrice = @0;
            newValue.date = [NSDate date];
            [newWorker addNewValueObject:newValue];
        }
    }
    
    //Add Insight
    Insight *model = [NSEntityDescription insertNewObjectForEntityForName:@"Insight" inManagedObjectContext:[CoreDataHelper managedContext]];

    model.firstName = @"Johnny";
    model.lastName = @"Appleseed";
    model.position = @"Expert";
    model.location = @"Cupertino, CA";
    model.comments = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
    model.company = @"Apple, Inc.";

    [newWorker addNewInsightObject:model];
    
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
    
    

    [CoreDataHelper saveContext];
    [LocationController getLocationData:newWorker];
//    [LocationController getZipCode:newWorker];
    [self grabUserConnections:newWorker inContext:[CoreDataHelper managedContext] atRange:0];
    
    //Parsing Connection info
//    [self grabUserConnections:newWorker inContext:[CoreDataHelper managedContext] atRange:0];
}

//Grabs the user's connection's and enters those into the database
-(void)grabUserConnections:(Worker *)worker inContext:(NSManagedObjectContext *)context atRange:(NSInteger)range {
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    
    NSString *connectionAccess = [NSString stringWithFormat:@"%@%@&format=json&start=%ld&count=200", @"https://api.linkedin.com/v1/people/~/connections:(id,first-name,last-name,num-connections,num-connections-capped,positions,public-profile-url,headline,industry,location,pictureUrl,picture-urls::(original))?oauth2_access_token=", accessToken, (long)range];
    
    NSURL *connectionURL = [NSURL URLWithString:connectionAccess];
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    
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
                    
                    [newConnection addNewJobObject:newJob];
                }
                
                if (newConnection.jobs.count > 0) {
                    NSArray *array = [ValueController jobValue:[ValueController careerSearch:newConnection]];
                    
                    for (NSDictionary *dict in [ValueController generateBackValues:array[0]]) {
                        Value *newValue = [NSEntityDescription insertNewObjectForEntityForName:@"Value" inManagedObjectContext:[CoreDataHelper managedContext]];
                        newValue.marketPrice = [dict objectForKey:@"value"];
                        newValue.date = [NSDate date];
                        [newConnection addNewValueObject:newValue];
                    }
                } else {
                    for (int i = 0; i < 6; i++) {
                        Value *newValue = [NSEntityDescription insertNewObjectForEntityForName:@"Value" inManagedObjectContext:[CoreDataHelper managedContext]];
                        newValue.marketPrice = @0;
                        newValue.date = [NSDate date];
                        [newConnection addNewValueObject:newValue];
                    }
                }
                
                //Locational Code
//                [LocationController getLocationData:newConnection];

                newConnection.locationAvailable = @0;
                
                [worker addConnectionsObject:newConnection];
            }
        }
        
        NSLog(@"Worker New Connections: %li", (long)worker.connections.count);
        
        [CoreDataHelper saveContext];
        
        [self.delegate setGamerData];
    }];

    [dataTask resume];
}

#pragma mark - Documents Path

+(NSString *)documentsDirectoryPath
{
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    return [documentsURL path];
}

//Checks to see which LinkedinUsers you have in common with another connection
-(NSArray *)commonConnectionsWithUser:(NSString *)userID
{
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.linkedin.com/v1/people/id=%@:(relation-to-viewer:(related-connections:(id,first-name,last-name,positions,location:(name),industry,num-connections)))?oauth2_access_token=AQW4krK0LXeaRN7-hFLju5dDQB-gFvnt8R65Mqi-2qBoh17xSpHR_xT7e-KoEG94hQMVgMuanKCj4XL27ApcXIJO85S6QYuFqPjCJSTkaNsQ9KqZEXh-InhN-yPTt8UhMzTY4kPMaJKqGW7zPlYnERVbAi-QOLSIcHMavjglQkVKoICcPrA&format=json", userID];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSDictionary *commonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    NSArray *array = [commonDictionary valueForKeyPath:@"relationToViewer.relatedConnections.values"];
    
    return array;
}


#pragma mark - NSURLSession Delegate Methods

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    
    if ([dataTask.taskDescription isEqualToString:@"currentUser"]) {
        [self parseUserData:data];
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
