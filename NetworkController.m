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
}


-(NSString *)convertURLToCode:(NSURL *)url
{
    NSString *query = [url query];
    NSArray *components = [query componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"=&"]];
    NSMutableArray *mutComponents = [components mutableCopy];
    
    NSLog(@"Components: %@", mutComponents);
    
    
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
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[token dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:@"json" forHTTPHeaderField:@"x-li-format"]; // per Linkedin API: https://developer.linkedin.com/documents/api-requests-json
    
    NSURLResponse *response;
    NSError *error;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
   NSString *tokenResponse = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
    NSLog(@"Token Response: %@", tokenResponse);
    
    NSDictionary *jsonObject=[NSJSONSerialization
                              JSONObjectWithData:responseData
                              options:NSJSONReadingMutableContainers
                              error:nil];
    self.accessToken = [jsonObject objectForKey:@"access_token"];
    NSLog(@"Access: %@", self.accessToken);
    
    [[NSUserDefaults standardUserDefaults] setObject:self.accessToken forKey:@"accessToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"Token is currently: %d", [self checkTokenIsCurrent]);
    
}

-(BOOL)checkTokenIsCurrent
{
    NSString *accessURL = [NSString stringWithFormat:@"%@%@&format=json", @"https://api.linkedin.com/v1/people/~:(id,first-name,last-name,industry,headline,location:(name),num-connections,picture-url,email-address,last-modified-timestamp,interests,languages,skills,certifications,three-current-positions,public-profile-url,educations,num-recommenders,recommendations-received)?oauth2_access_token=", [[NSUserDefaults standardUserDefaults] stringForKey:@"accessToken"]];

    NSURL *url = [NSURL URLWithString:accessURL];
    
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
    //Generating the NSMutableURLRequest with the base LinkedIN URL with token extension in the HTTP Body
    //    NSString *string = [NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~"]
    NSString *accessURL = [NSString stringWithFormat:@"%@%@&format=json", @"https://api.linkedin.com/v1/people/~:(id,first-name,last-name,industry,headline,location:(name),num-connections,picture-url,picture-urls::(original),email-address,last-modified-timestamp,interests,languages,skills,certifications,three-current-positions,public-profile-url,educations,num-recommenders,recommendations-received)?oauth2_access_token=", accessToken];
    
    NSLog(@"%@", accessURL);
    
    NSURL *url = [NSURL URLWithString:accessURL];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url];
    [dataTask setTaskDescription:@"currentUser"];
    
    [dataTask resume];

}

-(Gamer *)parseUserData:(NSData *)data {
    
    Gamer *gamer = [Gamer new];
    
//    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    Worker *newWorker = [NSEntityDescription insertNewObjectForEntityForName:@"Worker" inManagedObjectContext:[CoreDataHelper managedContext]];

    Value *newValue = [NSEntityDescription insertNewObjectForEntityForName:@"Value" inManagedObjectContext:[CoreDataHelper managedContext]];
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                               options:NSJSONReadingMutableLeaves
                                                                 error:nil];
    newValue.marketPrice = @1000000;
    newValue.date = [NSDate date];
    [newWorker addValuesObject:newValue];
    
    gamer.firstName = dictionary[@"firstName"];
    
    gamer.lastName = dictionary[@"lastName"];
    gamer.fullName = [NSString stringWithFormat:@"%@ %@", gamer.firstName, gamer.lastName];
    gamer.gamerID = dictionary[@"id"];
    gamer.gamerEmail = dictionary[@"emailAddress"];
    gamer.location = [dictionary valueForKeyPath:@"location.name"];
    gamer.linkedinURL = dictionary[@"publicProfileUrl"];
    gamer.numConnections = dictionary[@"numConnections"];
    gamer.numRecommenders = dictionary[@"numRecommenders"];
//    gamer.invitationSent = TRUE;
    gamer.expertInsightsArray = [NSMutableArray new];
    
    //Working on parsing current positions
    NSMutableArray *tempArray = [NSMutableArray new];
    NSArray *positionArray = [dictionary valueForKeyPath:@"threeCurrentPositions.values"];
    
    for (NSDictionary *positionDictionary in positionArray) {
        Job *newPosition = [NSEntityDescription insertNewObjectForEntityForName:@"Job" inManagedObjectContext:[CoreDataHelper managedContext]];
        
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
        
        //Core Data
        [newPosition setValue:@1 forKey:@"isCurrent"];
        [newPosition setValue:position.companyName forKey:@"name"];
        [newPosition setValue:[positionDictionary valueForKeyPath:@"company.id"] forKey:@"id"];
        [newPosition setValue:[positionDictionary valueForKeyPath:@"company.industry"] forKey:@"industry"];
        [newPosition setValue:[positionDictionary valueForKey:@"title"] forKey:@"title"];
        [newPosition setValue:[formatter dateFromString:startDate] forKey:@"startDate"];

        NSNumber *numFloat = [NSNumber numberWithFloat:(employmentLength / 60 / 60 / 24 / 365) * 12];
        [newPosition setValue:numFloat forKey:@"monthsInCurrentJob"];
        
        [newWorker addJobsObject:newPosition];
        
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
        School *newSchool = [NSEntityDescription insertNewObjectForEntityForName:@"School" inManagedObjectContext:[CoreDataHelper managedContext]];
        
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
        
        //Core Data
        [newSchool setValue:[educationDictionary valueForKey:@"id"] forKey:@"id"];
        [newSchool setValue:[educationDictionary valueForKey:@"schoolName"] forKey:@"name"];
        [newSchool setValue:[educationDictionary valueForKey:@"degree"] forKey:@"degree"];
        [newSchool setValue:[educationDictionary valueForKey:@"fieldOfStudy"] forKey:@"fieldOfStudy"];
        [newSchool setValue:[formatter dateFromString:startDate] forKey:@"startYear"];
        [newSchool setValue:[formatter dateFromString:endDate] forKey:@"endYear"];
        
        [newWorker addSchoolsObject:newSchool];
        
        
        [gamer.educationArray addObject:institution];
        
    }
    
    //Parsing Languages
    gamer.GamerLanguages = [NSMutableArray new];
    
    NSArray *languageArray = [dictionary valueForKeyPath:@"languages.values"];
    
    for (NSDictionary *languageDictionary in languageArray) {
        Language *language = [NSEntityDescription insertNewObjectForEntityForName:@"Language" inManagedObjectContext:[CoreDataHelper managedContext]];
        [language setValue:[languageDictionary valueForKey:@"id"] forKey:@"id"];
        [language setValue:[languageDictionary valueForKeyPath:@"language.name"] forKey:@"name"];
        [newWorker addLanguagesObject:language];
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
    
    //Converting NSDate to local time zone
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone localTimeZone];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm";
    NSString *timeStamp = [dateFormatter stringFromDate:gamer.lastLinkedinUpdate];
    NSLog(@"Last Updated: %@", timeStamp);
    
    //Grabbing the image URL
    gamer.imageURL = [NSURL URLWithString:[dictionary valueForKeyPath:@"pictureUrls.values"][0]];
    gamer.smallImageURL = [NSURL URLWithString:[dictionary valueForKey:@"pictureUrl"]];
    
    NSString *fullName = [NSString stringWithFormat:@"%@%@", gamer.firstName, gamer.lastName];
    gamer.imageLocalLocation = [NSString stringWithFormat:@"%@/%@.jpg", [self documentsDirectoryPath], fullName];
    gamer.smallImageLocalLocation = [NSString stringWithFormat:@"%@/%@_small.jpg", [self documentsDirectoryPath], fullName];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:gamer.imageLocalLocation];
    BOOL smallFileExists = [[NSFileManager defaultManager] fileExistsAtPath:gamer.smallImageLocalLocation];
    
    if (fileExists) {
        gamer.profileImage = [UIImage imageWithData:[NSData dataWithContentsOfMappedFile:gamer.imageLocalLocation]];
    }
    
    if (smallFileExists) {
        gamer.smallProfileImage = [UIImage imageWithData:[NSData dataWithContentsOfMappedFile:gamer.smallImageLocalLocation]];
    }
    
    
    //Check for full-size image
    //    if (!fileExists) {
    //        NSData *profilePicData = [NSData dataWithContentsOfURL:gamer.imageURL];
    //        [profilePicData writeToFile:gamer.imageLocalLocation atomically:YES];
    //        gamer.profileImage = [UIImage imageWithData:profilePicData];
    //    } else {
    //        gamer.profileImage = [UIImage imageWithData:[NSData dataWithContentsOfMappedFile:gamer.imageLocalLocation]];
    //    }
    
    //Check for small image
    //    if (!smalllFileExists) {
    //        NSData *profilePicData = [NSData dataWithContentsOfURL:gamer.smallImageURL];
    //        [profilePicData writeToFile:gamer.smallImageLocalLocation atomically:YES];
    //        gamer.smallProfileImage = [UIImage imageWithData:profilePicData];
    //    } else {
    //        gamer.smallProfileImage = [UIImage imageWithData:[NSData dataWithContentsOfMappedFile:gamer.smallImageLocalLocation]];
    //    }
    
    //Parsing Connection info


    [newWorker setValue:dictionary[@"id"] forKey:@"id"];
    [newWorker setValue:dictionary[@"firstName"] forKey:@"firstName"];
    [newWorker setValue:dictionary[@"lastName"] forKey:@"lastName"];
    [newWorker setValue:[dictionary valueForKeyPath:@"location.name"] forKey:@"location"];
    [newWorker setValue:dictionary[@"emailAddress"] forKey:@"emailAddress"];
    [newWorker setValue:gamer.headline forKey:@"headline"];
    [newWorker setValue:gamer.industry forKey:@"industry"];
    [newWorker setValue:dictionary[@"numConnections"] forKey:@"numConnections"];
    [newWorker setValue:dictionary[@"numRecommenders"] forKey:@"numRecommenders"];
    [newWorker setValue:[NSDate dateWithTimeIntervalSince1970:newDate] forKey:@"lastLinkedinUpdate"];
    [newWorker setValue:[dictionary valueForKeyPath:@"pictureUrls.values"][0] forKey:@"imageURL"];
    [newWorker setValue:[dictionary valueForKey:@"pictureUrl"] forKey:@"smallImageURL"];
    [newWorker setValue:dictionary[@"publicProfileUrl"] forKey:@"linkedinURL"];\
    

//
    NSError *error;
    [[CoreDataHelper managedContext] save:&error];
    
    gamer.connectionIDArray = [[NetworkController grabUserConnections:newWorker inContext:[CoreDataHelper managedContext]] mutableCopy];
    
    return gamer;

}

+(NSArray *)grabUserConnections:(Worker *)worker inContext:(NSManagedObjectContext *)context {
    NSMutableArray *connectionsArray = [NSMutableArray new];
    
//    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//    NSManagedObjectContext *context = [appDelegate managedObjectContext];
//    Worker *newWorker = [NSEntityDescription insertNewObjectForEntityForName:@"Worker" inManagedObjectContext:context];
    
//    NSFetchRequest *request = [NSFetchRequest new];
    
    
    
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"accessToken"];
    
    NSString *connectionAccess = [NSString stringWithFormat:@"%@%@&format=json", @"https://api.linkedin.com/v1/people/~/connections:(id,first-name,last-name,num-connections,num-connections-capped,positions,public-profile-url,headline,industry,location,pictureUrl,picture-urls::(original))?oauth2_access_token=", accessToken];
    
    NSURL *connectionURL = [NSURL URLWithString:connectionAccess];
    
    NSData *connectionData = [NSData dataWithContentsOfURL:connectionURL];
    NSDictionary *connectionDictionary = [NSJSONSerialization JSONObjectWithData:connectionData
                                                                         options:NSJSONReadingMutableLeaves
                                                                           error:nil];
    NSArray *connectionArray = connectionDictionary[@"values"];
    NSLog(@"Connections: %lu", (unsigned long)connectionArray.count);
    
    for (NSDictionary *connection in connectionArray) {
        Gamer *gamerConnection = [Gamer new];
        Connection *newConnection = [NSEntityDescription insertNewObjectForEntityForName:@"Connection" inManagedObjectContext:[CoreDataHelper managedContext]];
        
        Value *newValue = [NSEntityDescription insertNewObjectForEntityForName:@"Value" inManagedObjectContext:[CoreDataHelper managedContext]];
        
        newValue.marketPrice = @1000000;
        newValue.date = [NSDate date];
        [newConnection addValuesObject:newValue];
        
        gamerConnection.gamerID = connection[@"id"];
        gamerConnection.firstName = connection[@"firstName"];
        gamerConnection.lastName = connection[@"lastName"];
        gamerConnection.fullName = [NSString stringWithFormat:@"%@ %@", gamerConnection.firstName, gamerConnection.lastName];
        gamerConnection.invitationSent = FALSE;
        
        //Add a base value
        gamerConnection.valueArray = [NSMutableArray new];
        [gamerConnection.valueArray addObject:@"1,000,000"];
        
        gamerConnection.headline = connection[@"headline"];
        gamerConnection.industry = connection[@"industry"];
        
        

        gamerConnection.numConnections = connection[@"numConnections"];
        gamerConnection.imageURL = [NSURL URLWithString:[connection valueForKeyPath:@"pictureUrls.values"][0]];
        gamerConnection.smallImageURL = [NSURL URLWithString:[connection valueForKey:@"pictureUrl"]];

        gamerConnection.location = [connection valueForKeyPath:@"location.name"];
        gamerConnection.linkedinURL = [NSURL URLWithString:connection[@"publicProfileUrl"]];
        
        
        NSMutableArray *tempConnectionArray = [NSMutableArray new];
        NSArray *connectionPositionArray = [connection valueForKeyPath:@"positions.values"];
        
        for (NSDictionary *positionDictionary in connectionPositionArray) {
            Position *position = [Position new];
            Job *newJob = [NSEntityDescription insertNewObjectForEntityForName:@"Job" inManagedObjectContext:[CoreDataHelper managedContext]];
            
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
            
            //Core Data
            [newJob setValue:[company objectForKey:@"id"] forKey:@"id"];
            [newJob setValue:[company objectForKey:@"name"] forKey:@"name"];
            [newJob setValue:[company objectForKey:@"industry"] forKey:@"industry"];
            [newJob setValue:[positionDictionary valueForKey:@"title"] forKey:@"title"];
            [newJob setValue:[formatter dateFromString:startDate] forKey:@"startDate"];
            [newJob setValue:[NSNumber numberWithFloat:(employmentLength / 60 / 60 / 24 / 365) * 12] forKey:@"monthsInCurrentJob"];
            
            [newConnection addJobsObject:newJob];
            
            [tempConnectionArray addObject:position];
        }
        
        gamerConnection.currentPositionArray = tempConnectionArray;
        
        if ([gamerConnection.firstName isEqualToString:@"private"]) {
            //Private Users - contain no info
        } else {
            [connectionsArray addObject:gamerConnection];
            
            NSLog(@"Worker Of Name: %@", [worker valueForKey:@"firstName"]);
            
            //Add to Core Data
            [newConnection setValue:connection[@"id"] forKey:@"id"];
            [newConnection setValue:connection[@"firstName"] forKey:@"firstName"];
            [newConnection setValue:connection[@"lastName"] forKey:@"lastName"];
            [newConnection setValue:[connection valueForKeyPath:@"location.name"] forKey:@"location"];
            
            [newConnection setValue:@0 forKey:@"invitationSent"];
            [newConnection setValue:connection[@"headline"] forKey:@"headline"];
            [newConnection setValue:connection[@"industry"] forKey:@"industry"];
            [newConnection setValue:connection[@"numConnections"] forKey:@"numConnections"];
            [newConnection setValue:[connection valueForKeyPath:@"pictureUrls.values"][0] forKey:@"imageURL"];
            [newConnection setValue:[connection valueForKey:@"pictureUrl"] forKey:@"smallImageURL"];

            [newConnection setValue:connection[@"publicProfileUrl"] forKey:@"linkedinURL"];
            
            [worker addConnectionsObject:newConnection];
        }
    }
    
    NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:nameDescriptor];
    NSArray *sortedArray = [connectionsArray sortedArrayUsingDescriptors:sortDescriptors];
    
    NSError *error;
    [[CoreDataHelper managedContext] save:&error];
    
    return sortedArray;
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
        Gamer *newGamer = [self parseUserData:data];
        [self.delegate setGamerData:newGamer];
        NSLog(@"%@", newGamer.fullName);
        
    } else {
        NSLog(@"It is not");
    }
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask {
    
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    
}

@end
