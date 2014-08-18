//
//  UserInfoView.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/2/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "UserInfoView.h"
#import "Connection.h"
#import "Worker.h"
#import "Job.h"

@implementation UserInfoView

-(id)initWithFrame:(CGRect)frame andUser:(id)sender {
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;

        UILabel *userInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 128, 21)];
        userInfoLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0];
        userInfoLabel.text = @"USER INFO";
        [self addSubview:userInfoLabel];
        
        self.workExperienceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, userInfoLabel.frame.origin.y + 29, 300, 21)];
        self.workExperienceLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17.0];
        
        if ([sender isKindOfClass:[Connection class]]) {
            Connection *connection = (Connection *)sender;
            NSArray *array = [connection.jobs allObjects];
            Job *job = array[0];
        
            NSNumber *jobExists = [self isJobInSet:job.name andConnection:connection];
            float num = ceil([jobExists integerValue] *.3);
            
            if (num > 0) {
                self.workExperienceLabel.text = [NSString stringWithFormat:@"Work Exp: Top %.0f%%", num];
            } else {
                self.workExperienceLabel.text = [NSString stringWithFormat:@"Work Exp: Unranked"];
            }
            
        } else {
            self.workExperienceLabel.text = [NSString stringWithFormat:@"Work Exp: Top 10%%"];
        }
        
        [self addSubview:self.workExperienceLabel];
        
        self.educationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.workExperienceLabel.frame.origin.y + 29, 300, 21)];
        self.educationLabel.text = [NSString stringWithFormat:@"Education Exp: Top 5%%"];
        self.educationLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17.0];
        [self addSubview:self.educationLabel];
        
        self.linkedinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect linkedRect = CGRectMake(40, self.bounds.origin.y + self.frame.size.height - 70, 240, 50);
        self.linkedinButton.frame = linkedRect;
        [self.linkedinButton addTarget:self action:@selector(LinkedInAction) forControlEvents:UIControlEventTouchUpInside];
        [self.linkedinButton setTitle:@"See LinkedIn Summary" forState:UIControlStateNormal];
        self.linkedinButton.layer.borderWidth = 1.0;
        self.linkedinButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0];
        [self.linkedinButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.linkedinButton.layer.borderColor = [UIColor blackColor].CGColor;
        [self addSubview:self.linkedinButton];
 
        return self;
    }
    
    return nil;
}

-(void)LinkedInAction {
    NSLog(@"LINKEDIN");
}

-(NSNumber *)isJobInSet:(NSString *)companyName andConnection:(Connection *)connection {
    NSNumber *finalNumber;
    NSArray *array = [connection.jobs allObjects];
    
    NSDictionary *jobDictionary = @{@"Google": @1,
                                    @"SAS": @2,
                                    @"The Boston Consulting Group": @3,
                                    @"Edward Jones": @4,
                                    @"Quicken Loans": @5,
                                    @"Genentech": @6,
                                    @"salesforce.com": @7,
                                    @"Intuit": @8,
                                    @"Robert W. Baird & Co.": @9,
                                    @"DPR Construction": @10,
                                    @"Camden Property Trust": @11,
                                    @"Wegmans Food Markets": @12,
                                    @"David Weekley Homes": @13,
                                    @"Burns & McDonnell": @14,
                                    @"Hilcorp": @15,
                                    @"CHG Healthcare Services": @16,
                                    @"USAA": @17,
                                    @"Southern Ohio Medical Center": @18,
                                    @"Baptist Health South Florida": @19,
                                    @"Ultimate Software": @20,
                                    @"Kimpton Hotels & Restaurants": @21,
                                    @"W. L. Gore & Associates": @22,
                                    @"Plante Moran": @23,
                                    @"Scripps Health": @24,
                                    @"Atlantic Health System": @25,
                                    @"NuStar Energy": @26,
                                    @"ARI, Automotive Resources International": @27,
                                    @"The Container Store": @28,
                                    @"Rackspace Hosting": @29,
                                    @"St. Jude Children's Research Hospital": @30,
                                    @"Baker Donelson": @31,
                                    @"Qualcomm": @32,
                                    @"NetApp": @33,
                                    @"World Wide Technology": @34,
                                    @"OhioHealth": @35,
                                    @"Nugget Market": @36,
                                    @"JM Family Enterprises": @37,
                                    @"Zappos.com": @38,
                                    @"WellStar Health System": @39,
                                    @"Alston & Bird": @40,
                                    @"Perkins Coie": @41,
                                    @"Stryker": @42,
                                    @"Children's Healthcare of Atlanta": @43,
                                    @"Whole Foods Market": @44,
                                    @"Goldman Sachs Group": @45,
                                    @"Houston Methodist": @46,
                                    @"Allianz Life Insurance Company of North America": @47,
                                    @"QuikTrip": @48,
                                    @"TEKsystems": @49,
                                    @"FactSet Research Systems": @50,
                                    @"Chesapeake Energy": @51,
                                    @"Credit Acceptance": @52,
                                    @"Mayo Clinic": @53,
                                    @"CarMax": @54,
                                    @"Cisco": @55,
                                    @"Devon Energy": @56,
                                    @"Marriott International": @57,
                                    @"Aflac": @58,
                                    @"PCL Construction Enterprises": @59,
                                    @"Bingham McCutchen LLP": @60,
                                    @"Deloitte": @61,
                                    @"Meridian Health": @62,
                                    @"Build-A-Bear Workshop": @63,
                                    @"General Mills": @64,
                                    @"PricewaterhouseCoopers": @65,
                                    @"National Instruments": @66,
                                    @"American Express": @67,
                                    @"Roche Diagnostics Corporation": @68,
                                    @"Recreational Equipment, Inc. (REI)": @69,
                                    @"Autodesk": @70,
                                    @"Umpqua Bank": @71,
                                    @"Novo Nordisk": @72,
                                    @"Kimley-Horn and Associates": @73,
                                    @"Darden Restaurants": @74,
                                    @"Publix Super Markets": @75,
                                    @"Mars": @76,
                                    @"Bright Horizons Family Solutions": @77,
                                    @"Ernst & Young": @78,
                                    @"Discovery Communications": @79,
                                    @"KPMG": @80,
                                    @"Arnold & Porter": @81,
                                    @"TDIndustries": @82,
                                    @"Adobe Systems": @83,
                                    @"Intel": @84,
                                    @"Capital One": @85,
                                    @"Microsoft": @86,
                                    @"Sheetz": @87,
                                    @"Teach For America": @88,
                                    @"Nordstrom": @89,
                                    @"Accenture": @90,
                                    @"Four Seasons Hotels": @91,
                                    @"The Cheesecake Factory": @92,
                                    @"Hyland Software": @93,
                                    @"Mercedes-Benz USA": @94,
                                    @"Hyatt Hotels": @95,
                                    @"Navy Federal Credit Union": @96,
                                    @"EOG Resources": @97,
                                    @"Hitachi Data Systems": @98,
                                    @"Kiewit Corporation": @99,
                                    @"Cooley": @100
                                    };
    NSArray *jobArray = [jobDictionary allKeys];
    
//    NSPredicate *jobTitlePredicate = [NSPredicate predicateWithFormat:@"ANY SELF.jobs.title CONTAINS[cd] %@", searchText];
//    self.searchResultsArray = [self.connectionsArray filteredArrayUsingPredicate:jobTitlePredicate];
    
    for (Job *job in array) {
//        NSLog(@"Job: %@", job.name);
        NSPredicate *jobPredicate = [NSPredicate predicateWithFormat:@"%@ MATCHES[CD] description", job.name];
        NSArray *filtered = [jobArray filteredArrayUsingPredicate:jobPredicate];
        if (filtered.count > 0) {
            if (finalNumber == nil) {
                finalNumber = [jobDictionary objectForKey:job.name];
            } else if (finalNumber) {
                if ([jobDictionary objectForKey:job.name] < finalNumber) {
                    finalNumber = [jobDictionary objectForKey:job.name];
                } else {
                    
                }
            }
        }
    }

//    NSLog(@"Final Number: %ld", (long)[finalNumber integerValue]);

    
//    NSLog(@"Company Name: %@", companyName);
//    
//    NSLog(@"%@", filtered);

//    if ([jobDictionary objectForKey:companyName]) {
//        NSLog(@"Got it");
//        return [jobDictionary objectForKey:companyName];
//    } else {
//        NSLog(@"Don't got it");
//        return 0;
//    }

    if (finalNumber) {
//        NSLog(@"Final Number: %ld", (long)[finalNumber integerValue]);
        return finalNumber;
    } else {
        NSLog(@"Don't got it");
        return 0;
    }

    }

@end
