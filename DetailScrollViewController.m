//
//  DetailScrollViewController.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 6/23/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "DetailScrollViewController.h"
#import "SocialController.h"
#import "UIColor+BlankCheckColors.h"
#import "AppDelegate.h"
#import "ProblemView.h"
#import "Insight.h"
#import "Note.h"
#import "ValueController.h"
#import "LocationController.h"

@interface DetailScrollViewController ()

@property (nonatomic) UIView *overView, *expertInsightsView, *timelineView, *expertAppraisalView, *legendView;
@property (nonatomic) UserInfoView *userInfoView;
@property (nonatomic) ButtonMenuView *buttonMenu;

@property (nonatomic) IBOutlet GKLineGraph *graph;
@property (nonatomic, strong) NSArray *data, *fauxData;
@property (nonatomic, strong) NSArray *labels;

@property (nonatomic) BOOL fileExists;

@property (nonatomic) int frameHeight;
@property (nonatomic) UIImageView *profileImage;

@property (nonatomic) UIAlertView *alertView;

@end

@implementation DetailScrollViewController


//Setup the view based on whether it is a connection or the user
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Blank Check Labs";
    
    self.profileImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 80, 120, 120)];
    self.profileImage.layer.cornerRadius = 60.f;
    self.profileImage.layer.masksToBounds = TRUE;
    
    Value *currentValue;
    
    if ([self.detail isKindOfClass:[Connection class]]) {
        self.connection = (Connection *)self.detail;

//        [LocationController getZipCode:self.connection];
//        if ([self.connection.locationAvailable isEqual:@0]) {
////            [LocationController getLocationData:self.connection];
//            [LocationController getZipCode:self.connection];
//            self.connection.locationAvailable = @1;
//            [CoreDataHelper saveContext];
//        }
        
//        [LocationController getLocationData:self.connection.location];
        
        NSString *firstLetter = [self.connection.lastName substringWithRange:NSMakeRange(0, 1)];
        userNameLabel.text = [NSString stringWithFormat:@"%@ %@.", self.connection.firstName, firstLetter];
        
        if (self.connection.values.count == 0) {
            
            NSArray *array = [ValueController jobValue:[ValueController careerSearch:self.connection]];
            
            for (NSDictionary *dict in [ValueController generateBackValues:array[0]]) {
                Value *newValue = [NSEntityDescription insertNewObjectForEntityForName:@"Value" inManagedObjectContext:[CoreDataHelper managedContext]];
                newValue.marketPrice = [dict objectForKey:@"value"];
                newValue.date = [NSDate date];
                [self.connection addNewValueObject:newValue];
            }
            
            [CoreDataHelper saveContext];
            
            NSMutableArray *temp = [NSMutableArray new];
            NSArray *orderedArray = [self.connection.values array];

            for (int j = (int)orderedArray.count - 6; j < orderedArray.count; j++) {
                Value *value = [self.connection.values objectAtIndex:j];
                [temp addObject:value.marketPrice];
                
            }
            
            self.data = [NSArray arrayWithObjects:[temp copy], self.fauxData, nil];
            
            currentValue = [self.connection.values lastObject];
            
            NSNumberFormatter *formatter = [NSNumberFormatter new];
            [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
            valueLabel.text = [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:currentValue.marketPrice]];


        } else {
            
            NSMutableArray *temp = [NSMutableArray new];
            NSArray *orderedArray = [self.connection.values array];
            //            int count = self.connection.values.count;
            
            for (int j = (int)orderedArray.count - 6; j < orderedArray.count; j++) {
                Value *value = [self.connection.values objectAtIndex:j];
                [temp addObject:value.marketPrice];
                
            }
            
            currentValue = [self.connection.values lastObject];
            
            float topValue = [currentValue.marketPrice floatValue];
            float rounded = ceil((topValue/1000.0)+0.5);
            topValue = 1000.0 * rounded;
            
            float bottomValue;
            if ([currentValue.marketPrice integerValue] < 75000) {
                float difference = topValue - [currentValue.marketPrice floatValue];
                
                if (difference > 750) {
                    
                } else {
                    topValue += 1000;
                    
                }
                bottomValue = topValue - 5000;
            } else {
                float difference = topValue - [currentValue.marketPrice floatValue];

                if (difference > 2000) {
                    topValue += 1000;
                } else {
                    topValue += 2000;
                }
                bottomValue = topValue - 10000;
            }
            
//            float bottomValue = [tempNumber floatValue] - fraction;
//            bottomValue = 100.0 * floor((bottomValue/100.0)+0.5);
            
            NSNumber *topNumber = [NSNumber numberWithInt:(int)(topValue)];
            NSArray *topArray = @[topNumber, topNumber, topNumber, topNumber, topNumber, topNumber];

            NSNumber *bottomNumber = [NSNumber numberWithInt:(int)(bottomValue)];
            NSArray *bottomArray = @[bottomNumber, bottomNumber, bottomNumber, bottomNumber, bottomNumber, bottomNumber];
            
            NSNumber *middleValue = [NSNumber numberWithInt:(int)(([[temp firstObject] floatValue] + [[temp lastObject] floatValue]) / 2)];
            
            self.fauxData = @[middleValue, middleValue, middleValue, middleValue, middleValue, middleValue];
            
            self.data = [NSArray arrayWithObjects:[temp copy], self.fauxData, topArray, bottomArray, nil];
            
            NSNumberFormatter *formatter = [NSNumberFormatter new];
            [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
            valueLabel.text = [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:currentValue.marketPrice]];
        }
        
        [self setupGraph];
        
    }
    
    if ([self.detail isKindOfClass:[Worker class]]) {
        self.worker = (Worker *)self.detail;
        
        self.title = @"My Profile";
        
        NSString *firstLetter = [self.worker.lastName substringWithRange:NSMakeRange(0, 1)];
        userNameLabel.text = [NSString stringWithFormat:@"%@ %@.", self.worker.firstName, firstLetter];
        
        if (self.worker.values.count == 0) {
            
            NSMutableArray *temp = [NSMutableArray new];
            NSArray *orderedArray = [self.worker.values array];
            
            for (int j = (int)orderedArray.count - 6; j < orderedArray.count; j++) {
                Value *value = [self.worker.values objectAtIndex:j];
                [temp addObject:value.marketPrice];
                NSLog(@"Value%i: %@", j, value.marketPrice);
            }
            
            self.data = [NSArray arrayWithObjects:[temp copy], self.fauxData, nil];
            
        } else {
            
            NSMutableArray *temp = [NSMutableArray new];
            NSArray *orderedArray = [self.worker.values array];
            
            for (int j = (int)orderedArray.count - 6; j < orderedArray.count; j++) {
                Value *value = [self.worker.values objectAtIndex:j];
                [temp addObject:value.marketPrice];
                
            }
            
            currentValue = [self.worker.values lastObject];
            NSNumber *tempNumber = temp[0];
            
//            float fraction = [currentValue.marketPrice floatValue];
//            
//            fraction = 100.0 * floor(((fraction * .01)/100.0)+0.5);
            
            float topValue = [currentValue.marketPrice floatValue];// + fraction;// * 1.01;
            float rounded = ceil((topValue/1000.0)+0.5);
            topValue = 1000.0 * rounded;
            
            float bottomValue;
            if ([currentValue.marketPrice integerValue] < 75000) {
                float difference = topValue - [currentValue.marketPrice floatValue];
                
                if (difference > 750) {
                    
                } else {
                    topValue += 1000;
                    
                }
                bottomValue = topValue - 5000;
                
            } else {
                float difference = topValue - [currentValue.marketPrice floatValue];
                
                if (difference > 2000) {
                    topValue += 1000;
                } else {
                    topValue += 2000;
                }
                bottomValue = topValue - 10000;
            }

            NSNumber *topNumber = [NSNumber numberWithInt:(int)(topValue)];
            NSArray *topArray = @[topNumber, topNumber, topNumber, topNumber, topNumber, topNumber];
            
            NSNumber *bottomNumber = [NSNumber numberWithInt:(int)(bottomValue)];
            NSArray *bottomArray = @[bottomNumber, bottomNumber, bottomNumber, bottomNumber, bottomNumber, bottomNumber];
            
            NSNumber *middleValue = [NSNumber numberWithInt:(int)(([[temp firstObject] floatValue] + [[temp lastObject] floatValue]) / 2)];
            
            self.fauxData = @[middleValue, middleValue, middleValue, middleValue, middleValue, middleValue];
            
            self.data = [NSArray arrayWithObjects:[temp copy], self.fauxData, topArray, bottomArray, nil];
            
            NSNumberFormatter *formatter = [NSNumberFormatter new];
            [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
            valueLabel.text = [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:currentValue.marketPrice]];
        }
        
        [self setupGraph];
    }
    
    [self setProfileImage];
    
    scrollView.delegate = self;
    [scrollView setScrollEnabled:YES];
    
    [self loadGraphLegend];
    [self addButtonMenu];
    
    [self loadUserInfo];
    [self loadExpertInsights];
    [self loadTimeLine];
    [self loadExpertAppraisal];
    
//    self.frameHeight = 1590;
    self.frameHeight = self.expertAppraisalView.frame.origin.y + self.expertAppraisalView.frame.size.height;

}

-(void)setProfileImage {

    if ([self.detail isKindOfClass:[Connection class]]) {
        self.fileExists = [[NSFileManager defaultManager] fileExistsAtPath:self.connection.imageLocation];

        if (self.fileExists) {
            NSData *data = [NSData dataWithContentsOfMappedFile:self.connection.imageLocation];
            UIImage *image = [UIImage imageWithData:data];
            self.profileImage.image = image;
        } else {
            if (self.connection.imageURL) {
                NSURL *url = [NSURL URLWithString:self.connection.imageURL];
                NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
                
                NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
                NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration
                                                                      delegate:self
                                                                 delegateQueue:nil];
                
                NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:urlRequest];
                [downloadTask resume];
            } else {
                self.profileImage.image = [UIImage imageNamed:@"default-user"];
            }
        }
    }
    
    if ([self.detail isKindOfClass:[Worker class]]) {
        self.fileExists = [[NSFileManager defaultManager] fileExistsAtPath:self.worker.imageLocation];

        if (self.fileExists) {
            NSData *data = [NSData dataWithContentsOfMappedFile:self.worker.imageLocation];
            UIImage *image = [UIImage imageWithData:data];
            self.profileImage.image = image;
            [self.view setNeedsDisplay];
            
        } else {
            self.profileImage.image = [UIImage imageNamed:@"default-user"];
        }
    }
    
    [scrollView addSubview:self.profileImage];

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
        
    if ([self.detail isKindOfClass:[Connection class]]) {
        
        if ([self.connection.invitationSent integerValue] == 1) {
            [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.frameHeight)];
        } else {
            [self loadInviteView];
            [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
        }
        
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        
        [tracker send:[[[GAIDictionaryBuilder createAppView] set:@"Connection - Detail View"
                                                          forKey:kGAIScreenName] build]];


    }
    
    if ([self.detail isKindOfClass:[Worker class]]) {
        
        [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.frameHeight)];
        
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        
        [tracker send:[[[GAIDictionaryBuilder createAppView] set:@"Profile View"
                                                          forKey:kGAIScreenName] build]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    
//}

- (void)setupGraph {

    self.labels = @[@"01/12", @"07/12", @"01/13", @"07/13", @"01/14", @"07/14"];
    
    self.graph.dataSource = self;
    self.graph.lineWidth = 3.0;
    
    self.graph.valueLabelCount = 6;
    
    [self.graph draw];
    
    float finalNum = 0.0;
    if ([self.detail isKindOfClass:[Connection class]]) {
        Value *newValue = [self.connection.values lastObject];
        Value *oldValue = [self.connection.values objectAtIndex:self.connection.values.count - 2];
        
        finalNum = [newValue.marketPrice floatValue] - [oldValue.marketPrice floatValue];
    }
    
    if ([self.detail isKindOfClass:[Worker class]]) {
        
        Value *newValue = [self.worker.values lastObject];
        Value *oldValue = [self.worker.values objectAtIndex:self.worker.values.count - 2];

        finalNum = [newValue.marketPrice floatValue] - [oldValue.marketPrice floatValue];
        
    }

    UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.graph.frame.size.width - 150, self.graph.frame.size.height - 70, 80, 50)];
    
    if (finalNum > 0) {
        newLabel.text = [NSString stringWithFormat:@"+$%.0f", finalNum];
        newLabel.backgroundColor = [UIColor colorWithRed:0/255.0 green:153.0/255.0 blue:0/255.0 alpha:1];
    } else {
        newLabel.text = [NSString stringWithFormat:@"-$%.0f", fabs(finalNum)];
        newLabel.backgroundColor = [UIColor redColor];
    }
    
    newLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:22.0];
    [newLabel sizeToFit];
    
    CGRect newRect = CGRectMake((self.graph.frame.size.width - 25) - newLabel.frame.size.width, (self.graph.frame.size.height - 20) - newLabel.frame.size.height, newLabel.frame.size.width, newLabel.frame.size.height);
    newLabel.frame = newRect;
    
    newLabel.textColor = [UIColor whiteColor];
    
    [self.graph addSubview:newLabel];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Graph Legend

-(void)loadGraphLegend {
    NSLog(@"Graph: %@", NSStringFromCGRect(self.graph.frame));
    
    self.legendView = [[UIView alloc] initWithFrame:CGRectMake(0, self.graph.frame.origin.y + self.graph.frame.size.height, 320, 36)];
//    self.legendView.layer.borderWidth = 1.0;
//    self.legendView.layer.borderColor = [UIColor blackColor].CGColor;
    [scrollView addSubview:self.legendView];
    
    
    
    UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.legendView.frame.size.height / 2, 100, 20)];
    
    if ([self.detail isKindOfClass:[Connection class]]) {
        Connection *connection = (Connection *)self.detail;
        userLabel.text = [NSString stringWithFormat:@"%@", connection.firstName];
    } else {
        Worker *worker = (Worker *)self.detail;
        userLabel.text = [NSString stringWithFormat:@"%@", worker.firstName];
    }
    
    [userLabel sizeToFit];
    int startingPoint = (int)((scrollView.frame.size.width - 138 - 55 - userLabel.frame.size.width) / 2);
    
    userLabel.frame = CGRectMake(startingPoint, userLabel.frame.origin.y, userLabel.frame.size.width, 21);
    NSLog(@"User: %f", userLabel.frame.size.width);
    [self.legendView addSubview:userLabel];
    
    UIView *userLineView = [[UIView alloc] initWithFrame:CGRectMake(userLabel.frame.origin.x + userLabel.frame.size.width + 15, (self.legendView.frame.size.height / 2) + 8, 40, 3)];
    userLineView.backgroundColor = [UIColor gk_turquoiseColor];
    [self.legendView addSubview:userLineView];
    
    UILabel *averageLabel = [[UILabel alloc] initWithFrame:CGRectMake(userLineView.frame.origin.x + userLineView.frame.size.width + 20, self.legendView.frame.size.height / 2, 63, 21)];
    averageLabel.text = @"Average";
    
    [self.legendView addSubview:averageLabel];
    
    UIView *averageLineView = [[UIView alloc] initWithFrame:CGRectMake((averageLabel.frame.origin.x + averageLabel.frame.size.width) + 15, (self.legendView.frame.size.height / 2) + 8, 40, 3)];
    
    averageLineView.backgroundColor = [UIColor gk_peterRiverColor];
    [self.legendView addSubview:averageLineView];

}

#pragma mark - Button creation/actions

-(void)addButtonMenu {
    self.buttonMenu = [[ButtonMenuView alloc] initWithFrame:CGRectMake(20, (self.legendView.frame.origin.y + self.legendView.frame.size.height) + 20, 280, 82)];
    [scrollView addSubview:self.buttonMenu];

    [self.buttonMenu.followButton addTarget:self action:@selector(followAction) forControlEvents:UIControlEventTouchUpInside];

    [self.buttonMenu.outButton addTarget:self action:@selector(outAction) forControlEvents:UIControlEventTouchUpInside];

    [self.buttonMenu.noteButton addTarget:self action:@selector(noteAction) forControlEvents:UIControlEventTouchUpInside];

    [self.buttonMenu.shareButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];

    [self.buttonMenu.findSimilarButton addTarget:self action:@selector(findSimilarAction) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Button Actions

-(void)followAction {
    NSLog(@"Follow Action");
}

-(void)outAction {
    NSLog(@"Out Action");
}

-(void)noteAction {
    NSLog(@"Note Action");
//    UIAlertView *alertView = [[UIAlertView alloc] initWithFrame:CGRectMake(50, 100, 220, 300)];
    self.alertView = [[UIAlertView alloc] initWithTitle:@"Enter Your Notes Below" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Complete", nil];
    
    self.alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    UITextField *textfield = [self.alertView textFieldAtIndex:0];
    textfield.delegate = self;
    textfield.placeholder = @"Start typing here";
    
    [self.alertView show];
}

-(void)shareAction {
    NSLog(@"Share Action");
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Share this profile"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil otherButtonTitles:@"LinkedIn", @"Twitter", @"Facebook", nil];
    
    [actionSheet showInView:self.view];

}

-(void)findSimilarAction {
    NSLog(@"Find Similar Action");
}

-(void)inviteTarget {
    NSLog(@"Invitation Sent");
    [self.connection setValue:@1 forKey:@"invitationSent"];

    //Method to send invite to target
//    [SocialHelper sendInvitationToUserID:self.connection];
    
    [CoreDataHelper saveContext];
    
    [self.overView removeFromSuperview];
//    self.view.frame = CGRectMake(0, 0, 320, 1500);
    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.frameHeight)];
}

- (NSString *)documentsDirectoryPath
{
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    return [documentsURL path];
}

-(void)loadInviteView {
    //Add UIView over info to promote connection
    self.overView = [[UIView alloc] initWithFrame:CGRectMake(20, 210, scrollView.frame.size.width - 40, 1000)];
    self.overView.backgroundColor = [UIColor blankCheckBlue];
    self.overView.alpha = .9;
    self.overView.layer.zPosition = 2;
    [scrollView addSubview:self.overView];
    
    NSLog(@"Width: %f", self.overView.frame.size.width);
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.overView.frame.size.width - 40, 40)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.text = [NSString stringWithFormat:@"%@ has picked up the Blank Check yet.", self.connection.firstName];
    nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0];
    nameLabel.numberOfLines = 0;
    [nameLabel sizeToFit];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.alpha = 1;
    nameLabel.center = CGPointMake(self.overView.frame.size.width / 2, 50);
    [self.overView addSubview:nameLabel];
    
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, self.overView.frame.size.width - 40, 60)];
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    descriptionLabel.text = @"We provide better estimates when friends use Blank Check.";
    descriptionLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0];
    descriptionLabel.numberOfLines = 0;
    [descriptionLabel sizeToFit];
    descriptionLabel.textColor = [UIColor whiteColor];
    descriptionLabel.alpha = 1;
    descriptionLabel.center = CGPointMake(self.overView.frame.size.width / 2, nameLabel.center.y + 80);
    [self.overView addSubview:descriptionLabel];
    
    
    UIButton *inviteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    inviteButton.frame = CGRectMake(0, descriptionLabel.frame.origin.y + 100, 200, 60);
    inviteButton.center = CGPointMake(self.overView.frame.size.width / 2, descriptionLabel.center.y + 100);
    [inviteButton setTitle:[NSString stringWithFormat:@"Invite %@", self.connection.firstName] forState:UIControlStateNormal];
    [inviteButton addTarget:self action:@selector(inviteTarget) forControlEvents:UIControlEventTouchUpInside];
    [inviteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    inviteButton.backgroundColor = [UIColor whiteColor];
    [self.overView addSubview:inviteButton];
}

-(void)loadUserInfo {
//    self.userInfoView = [[UserInfoView alloc] initWithFrame:CGRectMake(0, 600, 320, 170) andUser:self.connection];
    self.userInfoView = [[UserInfoView alloc] initWithFrame:CGRectMake(0, (self.buttonMenu.frame.origin.y + self.buttonMenu.frame.size.height) + 10, 320, 170) andUser:self.connection];
//    self.legendView.frame.origin.y + self.legendView.frame.size.height
    [scrollView addSubview:self.userInfoView];
    

    
//    UILabel *userInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 128, 21)];
//    userInfoLabel.text = @"USER INFO";
//    userInfoLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0];
//    userInfoLabel.textColor = [UIColor blackColor];
//    [userInfoView addSubview:userInfoLabel];
//    
//    UILabel *workExperienceLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, userInfoView.frame.origin.y + 29, 128, 21)];
//    workExperienceLabel.text = [NSString stringWithFormat:@"Work Exp: Top 10%%"];
//    workExperienceLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17.0];
//    workExperienceLabel.textColor = [UIColor blackColor];
//    [userInfoView addSubview:workExperienceLabel];
//    
//    UILabel *educationLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, workExperienceLabel.frame.origin.y + 29, 128, 21)];
//    educationLabel.text = [NSString stringWithFormat:@"Education Exp: Top 5%%"];
//    educationLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17.0];
//    educationLabel.textColor = [UIColor blackColor];
//    [userInfoView addSubview:educationLabel];
}

-(void)loadExpertInsights {
    self.expertInsightsView = [[UIView alloc] initWithFrame:CGRectMake(0, self.userInfoView.frame.origin.y + self.userInfoView.frame.size.height, 320, 280)];
    [scrollView addSubview:self.expertInsightsView];
    
    UILabel *expertLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 206, 21)];
    expertLabel.text = @"EXPERT INSIGHTS";
    expertLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0];
    [self.expertInsightsView addSubview:expertLabel];
    
    Insight *model;
    if ([self.detail isKindOfClass:[Connection class]]) {
        model = self.connection.insights[0];
    } else {
        model = self.worker.insights[0];
    }
    
    ExpertInsightView *expert = [[ExpertInsightView alloc] initWithFrame:CGRectMake(0, 40, 320, 240) andExpertInsight:model];
    [self.expertInsightsView addSubview:expert];
}

-(void)loadTimeLine {
    self.timelineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.expertInsightsView.frame.origin.y + self.expertInsightsView.frame.size.height, 320, 130)];
    [scrollView addSubview:self.timelineView];
    
    UILabel *timelineLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 206, 21)];
    timelineLabel.text = @"TIMELINE";
    timelineLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0];
    [self.timelineView addSubview:timelineLabel];
    
    //Format Column Headers
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 40, 21)];
    dateLabel.attributedText = [[NSAttributedString alloc] initWithString:@"Date"
                                                    attributes:underlineAttribute];
    dateLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15.0];
    [self.timelineView addSubview:dateLabel];
    
    UILabel *eventLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 30, 100, 21)];
    eventLabel.attributedText = [[NSAttributedString alloc] initWithString:@"Event"
                                                               attributes:underlineAttribute];
    eventLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15.0];
    [self.timelineView addSubview:eventLabel];
    
    UILabel *salaryChangeLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 30, 100, 21)];
    salaryChangeLabel.attributedText = [[NSAttributedString alloc] initWithString:@"Salary Change"
                                                               attributes:underlineAttribute];
    salaryChangeLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15.0];
    [self.timelineView addSubview:salaryChangeLabel];
    
    NSString *stringDate = @"6/15/2012";
    NSDateFormatter *dateFormat = [NSDateFormatter new];
    dateFormat.dateStyle = NSDateFormatterShortStyle;
    
    TimelineEvent *event = [[TimelineEvent alloc] initWithEvent:@"College Degree" onDate:[dateFormat dateFromString:stringDate] withChange:[NSNumber numberWithInteger:20000]];
    
    NSString *stringDate2 = @"12/13/2013";
    
    TimelineView *timelineView = [[TimelineView alloc] initWithFrame:CGRectMake(0, 60, 320, 30) andTimelineEvent:event];
    [self.timelineView addSubview:timelineView];
    
    TimelineEvent *event2 = [[TimelineEvent alloc] initWithEvent:@"iOS Certification" onDate:[dateFormat dateFromString:stringDate2] withChange:[NSNumber numberWithInteger:-10000]];
    
    TimelineView *timelineView2 = [[TimelineView alloc] initWithFrame:CGRectMake(0, 90, 320, 30) andTimelineEvent:event2];
    [self.timelineView addSubview:timelineView2];
    
    
//    TimelineView *timelineView = [[TimelineView alloc] initWithFrame:CGRectMake(0, self.expertInsightsView.frame.origin.y + self.expertInsightsView.frame.size.height, 320, 320)];
//    [scrollView addSubview:timelineView];
    
//    UILabel *expertLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 206, 21)];
//    expertLabel.text = @"EXPERT INSIGHTS";
//    expertLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0];
//    expertLabel.textColor = [UIColor blackColor];
//    [expertInsightsView addSubview:expertLabel];
    
//    TimelineView *timeline = [[TimelineView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
//    [self.timelineView addSubview:timeline];
}

-(void)loadExpertAppraisal {
    self.expertAppraisalView = [[UIView alloc] initWithFrame:CGRectMake(0, self.timelineView.frame.origin.y + self.timelineView.frame.size.height, 320, 260)];
    [scrollView addSubview:self.expertAppraisalView];
    
    UILabel *expertLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 206, 21)];
    expertLabel.text = @"EXPERT APPRAISALS";
    expertLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0];
    expertLabel.textColor = [UIColor blackColor];
    [self.expertAppraisalView addSubview:expertLabel];
    
    ExpertAppraisal *appraisal = [[ExpertAppraisal alloc] init];
    
    ExpertAppraisalView *expertView = [[ExpertAppraisalView alloc] initWithFrame:CGRectMake(0, 30, 320, 100) andExpertAppraiser:appraisal];
    [self.expertAppraisalView addSubview:expertView];
    
    UIButton *estimateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect linkedRect = CGRectMake(40, expertView.frame.origin.y + expertView.frame.size.height + 20, 240, 50);
    estimateButton.frame = linkedRect;
    [estimateButton addTarget:self action:@selector(linkedInAction) forControlEvents:UIControlEventTouchUpInside];
    [estimateButton setTitle:@"Get All Estimates" forState:UIControlStateNormal];
    estimateButton.layer.borderWidth = 1.0;
    estimateButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0];
    [estimateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    estimateButton.layer.borderColor = [UIColor blackColor].CGColor;
    [self.expertAppraisalView addSubview:estimateButton];
    
}

-(void)linkedInAction {
    
}

#pragma mark - GKLineGraphDataSource

- (NSInteger)numberOfLines {
    return self.data.count;
}

- (UIColor *)colorForLineAtIndex:(NSInteger)index {
    id colors = @[
                  [UIColor gk_turquoiseColor],
                  [UIColor gk_peterRiverColor],
                  [UIColor clearColor],
                  [UIColor clearColor]
//                  [UIColor gk_alizarinColor],
//                  [UIColor gk_sunflowerColor]
                  ];
    return [colors objectAtIndex:index];
}

- (NSArray *)valuesForLineAtIndex:(NSInteger)index {
    return [self.data objectAtIndex:index];
}

- (CFTimeInterval)animationDurationForLineAtIndex:(NSInteger)index {
    return 0; //[[@[@0.5, @0.8, @1.1, @0.7] objectAtIndex:index] doubleValue];
}

- (NSString *)titleForLineAtIndex:(NSInteger)index {
    return [self.labels objectAtIndex:index];
}

#pragma mark - Social share

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (buttonIndex) {
        case 0:
        {
            NSLog(@"LinkedIn");
            [SocialHelper shareOnLinkedin:self.detail];
//            [SocialController shareOnLinkedin:self.connection];;
            //            [socialController shareOnFacebook:<#(Gamer *)#>]
            
        }    //            SLComposeViewController *viewController = [SocialController shareOnFacebook:gamer];
            break;
            
        case 1:
        {
            NSLog(@"Twitter");
//            SLComposeViewController *twitterViewController = [SocialController shareOnTwitter:self.connection];
//            
//            if (twitterViewController) {
//                [self presentViewController:twitterViewController animated:YES completion:nil];
//            } else {
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Twitter Account Available" message:@"Please enable Twitter to do this" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
//                [alertView show];
//            }
            [SocialHelper sendTwitterPost:self.detail];
        }
            break;
            
        case 2:
        {
            NSLog(@"Facebook");
            [SocialHelper sendFacebookPost:self.detail];
//            SLComposeViewController *facebookViewController = [SocialController shareOnFacebook:self.connection];
//            //
//            if (facebookViewController) {
//                [self presentViewController:facebookViewController animated:YES completion:nil];
//            } else {
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Facebook Account Available" message:@"Please enable Facebook to do this" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
//                [alertView show];
//            }
        }
            break;
    }
}

#pragma mark - URL Session delegate methods

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    
    NSData *data = [NSData dataWithContentsOfURL:location];
    UIImage *image = [UIImage imageWithData:data];
    [data writeToFile:self.connection.imageLocation atomically:YES];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.profileImage.image = image;
        [self.profileImage setNeedsDisplay];
        
    });
    
//    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//        [self.profileImage setNeedsDisplay];
//    }];
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
    NSLog(@"Written %lld - %lld", totalBytesWritten, totalBytesExpectedToWrite);
    
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
    
}

#pragma mark - Alertview methods
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        
    } else {
        UITextField *noteText = [alertView textFieldAtIndex:0];
        
        Note *note = [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:[CoreDataHelper managedContext]];

        note.date = [NSDate date];
        note.comments = noteText.text;
        note.connection = self.connection;

        [[CoreDataHelper currentUser] addNewNoteObject:note];
        
        [CoreDataHelper saveContext];
        
        NSLog(@"Note: %@", noteText.text);
    }
}

@end
