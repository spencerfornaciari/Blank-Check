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

@interface DetailScrollViewController ()

@property (nonatomic) UIView *overView, *expertInsightsView, *timelineView, *expertAppraisalView;
@property (nonatomic) UserInfoView *userInfoView;

@property (nonatomic, weak) IBOutlet GKLineGraph *graph;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSArray *labels;

@end

@implementation DetailScrollViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Blank Check Labs";
    
    scrollView.delegate = self;
    [scrollView setScrollEnabled:YES];
    
    [self setupGraph];

    
    [self loadUserInfo];
    [self loadExpertInsights];
    [self loadTimeLine];
    [self loadExpertAppraisal];
    
    [self addButtonMenu];
    
    
    
//    UIImageView *graph = [[UIImageView alloc] initWithFrame:CGRectMake(20, 230, self.view.frame.size.width-40, 236)]; //height should be: self.view.frame.size.width-40 , origin: 20, 210
//    graph.image = [UIImage imageNamed:@"graph"];
//    [scrollView addSubview:graph];
    

    NSString *fullName = [NSString stringWithFormat:@"%@%@", self.gamer.firstName, self.gamer.lastName];
    self.gamer.imageLocalLocation = [NSString stringWithFormat:@"%@/%@.jpg", [self documentsDirectoryPath], fullName];
    
//    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:self.gamer.imageLocalLocation];
    
    profileImage.image = self.gamer.profileImage;
    profileImage.layer.cornerRadius = 60.f;
    profileImage.layer.masksToBounds = TRUE;
    
    NSString *firstLetter = [self.gamer.lastName substringWithRange:NSMakeRange(0, 1)];
    
    userNameLabel.text = [NSString stringWithFormat:@"%@ %@.", self.gamer.firstName, firstLetter];
//    userNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0];
    valueLabel.text = [NSString stringWithFormat:@"$%@", [self.gamer.valueArray lastObject]];
//    valueLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.gamer.invitationSent) {
        [scrollView setContentSize:CGSizeMake(320, 1340)];
    } else {
        [self loadInviteView];
        [scrollView setContentSize:CGSizeMake(320, self.view.frame.size.height)];
    }
    
    profileImage.image = [UIImage imageNamed:@"default-user"];
    
    NSURL *url = self.gamer.imageURL;
    
    if (url) {
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        self.gamer.profileImage = image;
        //
        [data writeToFile:self.gamer.imageLocalLocation atomically:YES];
        profileImage.image = self.gamer.profileImage;
        [profileImage setNeedsDisplay];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

- (void)setupGraph {
    
    self.data = @[
                  @[@20, @40, @20, @60, @40, @140, @80],
                  @[@40, @20, @60, @100, @60, @20, @60],
                  @[@80, @60, @40, @160, @100, @40, @110],
                  @[@120, @150, @80, @120, @140, @100, @0],
                  //                  @[@620, @650, @580, @620, @540, @400, @0]
                  ];
    
    self.labels = @[@"2001", @"2002", @"2003", @"2004", @"2005", @"2006", @"2007"];
    
    self.graph.dataSource = self;
    self.graph.lineWidth = 3.0;
    
    self.graph.valueLabelCount = 6;
    
    [self.graph draw];
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

#pragma mark - Button creation/actions

-(void)addButtonMenu {
    
    UIButton *followButton = [UIButton buttonWithType:UIButtonTypeCustom];
    followButton.frame = CGRectMake(20, 500, 56, 56);
    [followButton setImage:[UIImage imageNamed:@"follow"] forState:UIControlStateNormal];
    [followButton addTarget:self action:@selector(followAction) forControlEvents:UIControlEventTouchUpInside];
    followButton.layer.borderWidth = 1.0;
    followButton.layer.borderColor = [UIColor blackColor].CGColor;
    [scrollView addSubview:followButton];
    
    UILabel *followLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 561, 56, 21)];
    followLabel.text = @"Follow";
    followLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:11.0];
    followLabel.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:followLabel];
    
    UIButton *outButton = [UIButton buttonWithType:UIButtonTypeCustom];
    outButton.frame = CGRectMake(76, 500, 56, 56);
    [outButton setImage:[UIImage imageNamed:@"out"] forState:UIControlStateNormal];
    [outButton addTarget:self action:@selector(outAction) forControlEvents:UIControlEventTouchUpInside];
    outButton.layer.borderWidth = 1.0;
    outButton.layer.borderColor = [UIColor blackColor].CGColor;
    [scrollView addSubview:outButton];
    
    UILabel *outLabel = [[UILabel alloc] initWithFrame:CGRectMake(76, 561, 56, 21)];
    outLabel.text = @"X-Out";
    outLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:11.0];
    outLabel.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:outLabel];
    
    UIButton *noteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    noteButton.frame = CGRectMake(132, 500, 56, 56);
    [noteButton setImage:[UIImage imageNamed:@"note"] forState:UIControlStateNormal];
    [noteButton addTarget:self action:@selector(noteAction) forControlEvents:UIControlEventTouchUpInside];
    noteButton.layer.borderWidth = 1.0;
    noteButton.layer.borderColor = [UIColor blackColor].CGColor;
    [scrollView addSubview:noteButton];
    
    UILabel *noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(132, 561, 56, 21)];
    noteLabel.text = @"Note";
    noteLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:11.0];
    noteLabel.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:noteLabel];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(188, 500, 56, 56);
    [shareButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    shareButton.layer.borderWidth = 1.0;
    shareButton.layer.borderColor = [UIColor blackColor].CGColor;
    [scrollView addSubview:shareButton];
    
    UILabel *shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(188, 561, 56, 21)];
    shareLabel.text = @"Share";
    shareLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:11.0];
    shareLabel.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:shareLabel];
    
    UIButton *findSimilarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    findSimilarButton.frame = CGRectMake(244, 500, 56, 56);
    [findSimilarButton setImage:[UIImage imageNamed:@"findSimilar"] forState:UIControlStateNormal];
    [findSimilarButton addTarget:self action:@selector(findSimilarAction) forControlEvents:UIControlEventTouchUpInside];
    findSimilarButton.layer.borderWidth = 1.0;
    findSimilarButton.layer.borderColor = [UIColor blackColor].CGColor;
    [scrollView addSubview:findSimilarButton];
    
    UILabel *findSimilarLabel = [[UILabel alloc] initWithFrame:CGRectMake(244, 561, 60, 21)];
    findSimilarLabel.text = @"Find Similar";
    findSimilarLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:11.0];
    findSimilarLabel.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:findSimilarLabel];
}

-(void)followAction {
    NSLog(@"Follow Action");
}

-(void)outAction {
    NSLog(@"Out Action");
}

-(void)noteAction {
    NSLog(@"Note Action");
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

-(void)inviteTarget:(Gamer *)gamer {
    NSLog(@"Invitation Sent");
    self.gamer.invitationSent = TRUE;
    [self.overView removeFromSuperview];
//    self.view.frame = CGRectMake(0, 0, 320, 1500);
    [scrollView setContentSize:CGSizeMake(320, 1340)];
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
    nameLabel.text = [NSString stringWithFormat:@"%@ has picked up the Blank Check yet.", self.gamer.firstName];
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
    [inviteButton setTitle:[NSString stringWithFormat:@"Invite %@", self.gamer.firstName] forState:UIControlStateNormal];
    [inviteButton addTarget:self action:@selector(inviteTarget:) forControlEvents:UIControlEventTouchUpInside];
    [inviteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    inviteButton.backgroundColor = [UIColor whiteColor];
    [self.overView addSubview:inviteButton];
}

-(void)loadUserInfo {
    self.userInfoView = [[UserInfoView alloc] initWithFrame:CGRectMake(0, 600, 320, 170)];
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
    
    ExpertInsight *model = [ExpertInsight new];
    
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
    self.expertAppraisalView = [[UIView alloc] initWithFrame:CGRectMake(0, self.timelineView.frame.origin.y + self.timelineView.frame.size.height, 320, 200)];
    [scrollView addSubview:self.expertAppraisalView];
    
    UILabel *expertLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 206, 21)];
    expertLabel.text = @"EXPERT APPRAISALS";
    expertLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0];
    expertLabel.textColor = [UIColor blackColor];
    [self.expertAppraisalView addSubview:expertLabel];
    
    ExpertAppraisal *appraisal = [[ExpertAppraisal alloc] init];
    
    ExpertAppraisalView *expertView = [[ExpertAppraisalView alloc] initWithFrame:CGRectMake(0, 30, 320, 200) andExpertAppraiser:appraisal];
    [self.expertAppraisalView addSubview:expertView];
}

#pragma mark - GKLineGraphDataSource

- (NSInteger)numberOfLines {
    return [self.data count];
}

- (UIColor *)colorForLineAtIndex:(NSInteger)index {
    id colors = @[[UIColor gk_turquoiseColor],
                  [UIColor gk_peterRiverColor],
                  [UIColor gk_alizarinColor],
                  [UIColor gk_sunflowerColor]
                  ];
    return [colors objectAtIndex:index];
}

- (NSArray *)valuesForLineAtIndex:(NSInteger)index {
    return [self.data objectAtIndex:index];
}

- (CFTimeInterval)animationDurationForLineAtIndex:(NSInteger)index {
    return 0; //[[@[@1, @1.6, @2.2, @1.4] objectAtIndex:index] doubleValue];
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
            [SocialController shareOnLinkedin:self.gamer];;
            //            [socialController shareOnFacebook:<#(Gamer *)#>]
            
        }    //            SLComposeViewController *viewController = [SocialController shareOnFacebook:gamer];
            break;
            
        case 1:
        {
            NSLog(@"Twitter");
            SLComposeViewController *twitterViewController = [SocialController shareOnTwitter:self.gamer];
            
            if (twitterViewController) {
                [self presentViewController:twitterViewController animated:YES completion:nil];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Twitter Account Available" message:@"Please enable Twitter to do this" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
            break;
            
        case 2:
        {
            NSLog(@"Facebook");
            SLComposeViewController *facebookViewController = [SocialController shareOnFacebook:self.gamer];
            //
            if (facebookViewController) {
                [self presentViewController:facebookViewController animated:YES completion:nil];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Facebook Account Available" message:@"Please enable Facebook to do this" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
            break;
    }
}

@end
