//
//  ViewController.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 5/15/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "ViewController.h"
#import "NetworkController.h"
#import "Gamer.h"
#import "Position.h"
#import "Education.h"
#import "Language.h"
#import "Recommendation.h"

@interface ViewController ()

@property (nonatomic) UIWebView *webView;
@property (nonatomic) NSString *authorizationString, *accessToken;
@property (nonatomic) BOOL tokenBOOL, tokenStatus, haveRunJSON;
@property (nonatomic) Gamer *currentGamer;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Blank Check";
    
    self.tokenBOOL = FALSE;
    self.haveRunJSON = FALSE;
    
    self.currentGamer = [Gamer new];
    self.controller = [(AppDelegate *)[[UIApplication sharedApplication] delegate] networkController];
    
    //Check to see if there is an access token already, otherwise get a new one
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"accessToken"]) {
        self.tokenStatus = [self.controller checkTokenIsCurrent];
        NSLog(@"Boolean status: %d", self.tokenStatus);
        
        //Check to see if existing access token is still valid, otherwise get a new one
        if (self.tokenStatus){
            self.accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"accessToken"];
            
            [self testJSON];
        } else {
            
            [self newOAuth];
        }
    } 
    
    else {
        
        [self newOAuth];
    }
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    self.webView.layer.zPosition = 0;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    self.controller = self.appDelegate.networkController;
    

    

    
    
//    NSString *url = [self.controller handleCallbackURL:self.authorizationString];

    
    
//    [NetworkController beginOAuthAccess];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)newOAuth
{
    NSString *string = [self.controller beginOAuthAccess];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSURL *url = [NSURL URLWithString:string];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [self.webView loadRequest:request];
    }];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSURLRequest *currentRequest = [self.webView request];
    NSURL *currentURL = [currentRequest URL];
//    NSLog(@"Current URL is %@", currentURL.absoluteString);
    
    self.authorizationString = [self.controller convertURLToCode:currentURL];
    
    if (self.authorizationString && self.tokenBOOL == FALSE) {
        [self.controller handleCallbackURL:self.authorizationString];
        NSLog(@"Auth: %@", self.authorizationString);
        self.tokenBOOL = TRUE;
    }
    
    if (self.tokenBOOL && self.haveRunJSON == FALSE) {
        NSLog(@"We have an auth token");
        [self testJSON];
        [self.webView removeFromSuperview];
        self.haveRunJSON = TRUE;
    }
    

    
//    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"accessToken"]) {
//        NSString *string = [NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~?oauth2_access_token=%@&%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"accessToken"], @"format=json"];
//        NSLog(@"String: %@", string);
        
//    }

//    NSLog(@"Default Access Token: %@", [[NSUserDefaults standardUserDefaults] stringForKey:@"accessToken"]);
//    NSLog(@"TOKEN: %@", url);
//    if ([self.controller convertURLToCode:currentURL]) {
//        NSString *url = [self.controller handleCallbackURL:string];
//        NSLog(@"TOKEN: %@", url);
//    }
    
}

-(void)testJSON
{
    
    //Generating the NSMutableURLRequest with the base LinkedIN URL with token extension in the HTTP Body
//    NSString *string = [NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~"]
    [self.webView removeFromSuperview];
    
    NSString *accessURL = [NSString stringWithFormat:@"%@%@&format=json", @"https://api.linkedin.com/v1/people/~:(id,first-name,last-name,industry,headline,location:(name),num-connections,picture-url,email-address,last-modified-timestamp,interests,languages,skills,certifications,three-current-positions,public-profile-url,educations,num-recommenders,recommendations-received)?oauth2_access_token=", self.accessToken];
    
    /*NSURL *url = [NSURL URLWithString:@"https://api.linkedin.com/v1/people/~:(id,first-name,last-name,industry,headline,location:(name),num-connections,picture-url,email-address,last-modified-timestamp,interests,languages,skills,certifications,three-current-positions,public-profile-url,educations,num-recommenders,recommendations-received)?oauth2_access_token=AQWlBgoqxdW9OLFOg1UUEGFt_Re-vnQLw7F9lTHXM6QzPBiT0iWzXOQQHP49hfmfm21N2n7LGhAnDRB3tsYdnfoQK9sG8KMDjrVVeTp5Psld5VAkE0ACHcd0MDrdT0_VOfVXLbDIc4wfqL3tlrnvGuqHcs2TeRwxTL4nzL_oVTM8e9NVeE8&format=json"];*/
    
    NSURL *url = [NSURL URLWithString:accessURL];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                               options:NSJSONReadingMutableLeaves
                                                                 error:nil];
    
    self.currentGamer.firstName = dictionary[@"firstName"];
    self.currentGamer.lastName = dictionary[@"lastName"];
    self.currentGamer.gamerID = dictionary[@"id"];
    self.currentGamer.gamerEmail = dictionary[@"emailAddress"];
    self.currentGamer.location = [dictionary valueForKeyPath:@"location.name"];
    self.currentGamer.linkedinURL = dictionary[@"publicProfileUrl"];
    self.currentGamer.numConnections = dictionary[@"numConnections"];
    self.currentGamer.numRecommenders = dictionary[@"numRecommenders"];
    
    //Working on parsing current positions
    NSMutableArray *tempArray = [NSMutableArray new];
//    NSLog(@"%@", postArray[0]);
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
        NSLog(@"Start Date: %@", position.startDate);
        
        NSDate *date = [NSDate date];
        NSTimeInterval employmentLength = [date timeIntervalSinceDate:position.startDate];
        //Conversion from seconds to months
        position.monthsInCurrentJob = (employmentLength / 60 / 60 / 24 / 365) * 12;
        
        [tempArray addObject:position];
    }
    
    self.currentGamer.currentPositionArray = tempArray;
    
//    NSLog(@"%@", positionArray[0]);
    
    //Parsing skills
    self.currentGamer.gamerSkills = [NSMutableArray new];
    NSArray *skillsArray = [dictionary valueForKeyPath:@"skills.values"];
    
    for (NSDictionary *skillsDictionary in skillsArray) {
        NSString *skill = [skillsDictionary valueForKeyPath:@"skill.name"];
        [self.currentGamer.gamerSkills addObject:skill];
    }
    
    
    //Parsing Educational Institutions
    self.currentGamer.educationArray = [NSMutableArray new];
    
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
        
        [self.currentGamer.educationArray addObject:institution];
        
    }
    
    //Parsing Languages
    self.currentGamer.GamerLanguages = [NSMutableArray new];
    
    NSArray *languageArray = [dictionary valueForKeyPath:@"languages.values"];
    
    for (NSDictionary *languageDictionary in languageArray) {
        Language *language = [Language new];
        language.languageID = [languageDictionary valueForKey:@"id"];
        language.languageName = [languageDictionary valueForKeyPath:@"language.name"];
        
        [self.currentGamer.gamerLanguages addObject:language];
    }

    //Parsing Recommendations
    self.currentGamer.gamerRecommendations = [NSMutableArray new];
    
    NSArray *recommendationArray = [dictionary valueForKeyPath:@"recommendationsReceived.values"];
    
    for (NSDictionary *recommendationDictionary in recommendationArray) {
        Recommendation *recommendation = [Recommendation new];
        recommendation.recommendationID = [recommendationDictionary valueForKey:@"id"];
        recommendation.recommendationText = [recommendationDictionary valueForKey:@"recommendationText"];
        recommendation.recommendationType = [recommendationDictionary valueForKeyPath:@"recommendationType.code"];
        recommendation.recommenderID = [recommendationDictionary valueForKeyPath:@"recommender.id"];
        recommendation.firstName = [recommendationDictionary valueForKeyPath:@"recommender.firstName"];
        recommendation.lastName = [recommendationDictionary valueForKeyPath:@"recommender.lastName"];
        
        [self.currentGamer.gamerRecommendations addObject:recommendation];
    }
    
    //Parsing last updated time (and millisecond conversion)
    NSNumber *date = [dictionary valueForKey:@"lastModifiedTimestamp"];
    float newDate = [date floatValue] / 1000;
    self.currentGamer.lastLinkedinUpdate = [NSDate dateWithTimeIntervalSince1970:newDate];

    
    //Grabbing the original image link ----> needs to be refactored so we don't have to download it everytime
    NSString *imageString = [NSString stringWithFormat:@"%@%@&format=json", @"https://api.linkedin.com/v1/people/~/picture-urls::(original)?oauth2_access_token=", self.accessToken];
    
    /*NSURL *imageURL = [NSURL URLWithString:@"https://api.linkedin.com/v1/people/~/picture-urls::(original)?oauth2_access_token=AQWlBgoqxdW9OLFOg1UUEGFt_Re-vnQLw7F9lTHXM6QzPBiT0iWzXOQQHP49hfmfm21N2n7LGhAnDRB3tsYdnfoQK9sG8KMDjrVVeTp5Psld5VAkE0ACHcd0MDrdT0_VOfVXLbDIc4wfqL3tlrnvGuqHcs2TeRwxTL4nzL_oVTM8e9NVeE8&format=json"];*/
    
    NSURL *imageURL = [NSURL URLWithString:imageString];
    
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    
    NSDictionary *dictionary2 = [NSJSONSerialization JSONObjectWithData:imageData
                                                               options:NSJSONReadingMutableLeaves
                                                                 error:nil];
    
    
    NSArray *array = dictionary2[@"values"];
    self.currentGamer.imageURL = [NSURL URLWithString:array[0]];
    NSString *fullName = [NSString stringWithFormat:@"%@%@", self.currentGamer.firstName, self.currentGamer.lastName];
    self.currentGamer.imageLocalLocation = [NSString stringWithFormat:@"%@/%@.jpg", [self documentsDirectoryPath], fullName];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:self.currentGamer.imageLocalLocation];
    
    if (!fileExists) {
        NSData *profilePicData = [NSData dataWithContentsOfURL:self.currentGamer.imageURL];
        [profilePicData writeToFile:self.currentGamer.imageLocalLocation atomically:YES];
        self.currentGamer.profileImage = [UIImage imageWithData:profilePicData];
    } else {
        self.currentGamer.profileImage = [UIImage imageWithData:[NSData dataWithContentsOfMappedFile:self.currentGamer.imageLocalLocation]];
    }
   
    
    
    
    //Parsing Connection info
    self.currentGamer.connectionIDArray = [NSMutableArray new];
    
    NSString *connectionAccess = [NSString stringWithFormat:@"%@%@&format=json", @"https://api.linkedin.com/v1/people/~/connections?oauth2_access_token=", self.accessToken];
    
    NSURL *connectionURL = [NSURL URLWithString:connectionAccess];
    
    /*NSURL *connectionURL = [NSURL URLWithString:@"https://api.linkedin.com/v1/people/~/connections?oauth2_access_token=AQWlBgoqxdW9OLFOg1UUEGFt_Re-vnQLw7F9lTHXM6QzPBiT0iWzXOQQHP49hfmfm21N2n7LGhAnDRB3tsYdnfoQK9sG8KMDjrVVeTp5Psld5VAkE0ACHcd0MDrdT0_VOfVXLbDIc4wfqL3tlrnvGuqHcs2TeRwxTL4nzL_oVTM8e9NVeE8&format=json"];*/
    
    NSData *connectionData = [NSData dataWithContentsOfURL:connectionURL];
    NSDictionary *connectionDictionary = [NSJSONSerialization JSONObjectWithData:connectionData
                                                                         options:NSJSONReadingMutableLeaves
                                                                           error:nil];
    NSArray *connectionArray = connectionDictionary[@"values"];
    
    for (NSDictionary *connection in connectionArray) {
        Gamer *gamer = [Gamer new];
        gamer.firstName = connection[@"firstName"];
        gamer.lastName = connection[@"lastName"];
        gamer.gamerID = connection[@"id"];
        
        [self.currentGamer.connectionIDArray addObject:gamer];
    }
    
    
    UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 75, 320, 40)];
    newLabel.text = [NSString stringWithFormat:@"%@ %@", self.currentGamer.firstName, self.currentGamer.lastName];
    newLabel.font =[UIFont fontWithName:@"Avenir" size:33.0];
    newLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:newLabel];
    newLabel.layer.zPosition = 3;
    
    UILabel *yourValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 160, 80, 20)];
    yourValueLabel.text = @"Your value";
    yourValueLabel.textAlignment = NSTextAlignmentRight;
//    [yourValueLabel sizeToFit];
    [self.view addSubview:yourValueLabel];
    yourValueLabel.layer.zPosition = 3;
    
    UILabel *currentValue = [[UILabel alloc] initWithFrame:CGRectMake(200, 180, 80, 20)];
    currentValue.text = @"$1,000,000";
    currentValue.textAlignment = NSTextAlignmentRight;
//    [currentValue sizeToFit];
    [self.view addSubview:currentValue];
    currentValue.layer.zPosition = 3;
    
    UILabel *currentValueChange = [[UILabel alloc] initWithFrame:CGRectMake(200, 200, 80, 20)];
    currentValueChange.text = [NSString stringWithFormat:@"+$50,000"];
    currentValueChange.numberOfLines = 1;
    currentValueChange.textColor = [UIColor whiteColor];
    currentValueChange.backgroundColor = [UIColor redColor];
    currentValueChange.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:currentValueChange];
    currentValueChange.layer.zPosition = 3;
    
    //Add profile picture
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 120, 120, 120)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.layer.cornerRadius = 60.f;
    imageView.layer.masksToBounds = TRUE;
    imageView.layer.zPosition = 4;
    
    imageView.image = self.currentGamer.profileImage;
    [self.view addSubview:imageView];
    
    //Block off space for graph
    UIImageView *graph = [[UIImageView alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height-(self.view.frame.size.width-20), self.view.frame.size.width-40, self.view.frame.size.width-40)];
    graph.backgroundColor = [UIColor blankCheckBlue];
    [self.view addSubview:graph];
    graph.layer.zPosition = 3;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)documentsDirectoryPath
{
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    return [documentsURL path];
}

@end
