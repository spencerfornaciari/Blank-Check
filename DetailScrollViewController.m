//
//  DetailScrollViewController.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 6/23/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "DetailScrollViewController.h"
#import "UIColor+BlankCheckColors.h"

@interface DetailScrollViewController ()

@property (nonatomic) UIView *overView, *timelineView, *expertAppraisalView;
@property (nonatomic) UserInfoView *userInfoView;
@property (nonatomic) ExpertInsightView *expertInsightsView;

@end

@implementation DetailScrollViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Blank Check Labs";
    
    scrollView.delegate = self;
    
    NSLog(@"Invitation sent: %d", self.gamer.invitationSent);
    
    [scrollView setScrollEnabled:YES];
    
    [self loadUserInfo];
    [self loadExpertInsights];
    [self loadTimeLine];
//    [self loadExpertAppraisal];
    
    [self addButtonMenu];
    
    UIImageView *graph = [[UIImageView alloc] initWithFrame:CGRectMake(20, 210, self.view.frame.size.width-40, self.view.frame.size.width-40)];
    graph.backgroundColor = [UIColor blankCheckBlue];
    [scrollView addSubview:graph];
    

    NSString *fullName = [NSString stringWithFormat:@"%@%@", self.gamer.firstName, self.gamer.lastName];
    self.gamer.imageLocalLocation = [NSString stringWithFormat:@"%@/%@.jpg", [self documentsDirectoryPath], fullName];
    
//    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:self.gamer.imageLocalLocation];
    
    profileImage.image = self.gamer.profileImage;
    profileImage.layer.cornerRadius = 60.f;
    profileImage.layer.masksToBounds = TRUE;
    
    NSString *firstLetter = [self.gamer.lastName substringWithRange:NSMakeRange(0, 1)];
    
    userNameLabel.text = [NSString stringWithFormat:@"%@ %@.", self.gamer.firstName, firstLetter];
    valueLabel.text = [NSString stringWithFormat:@"$%@", [self.gamer.valueArray lastObject]];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.gamer.invitationSent) {
        [scrollView setContentSize:CGSizeMake(320, 1000)];
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
    [followButton setImage:[UIImage imageNamed:@"Social-Share"] forState:UIControlStateNormal];
    [followButton addTarget:self action:@selector(followAction) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:followButton];
    
    UIButton *outButton = [UIButton buttonWithType:UIButtonTypeCustom];
    outButton.frame = CGRectMake(76, 500, 56, 56);
    [outButton setImage:[UIImage imageNamed:@"Social-Share"] forState:UIControlStateNormal];
    [outButton addTarget:self action:@selector(outAction) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:outButton];
    
    UIButton *noteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    noteButton.frame = CGRectMake(132, 500, 56, 56);
    [noteButton setImage:[UIImage imageNamed:@"Social-Share"] forState:UIControlStateNormal];
    [noteButton addTarget:self action:@selector(noteAction) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:noteButton];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(188, 500, 56, 56);
    [shareButton setImage:[UIImage imageNamed:@"Social-Share"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:shareButton];
    
    UIButton *findSimilarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    findSimilarButton.frame = CGRectMake(244, 500, 56, 56);
    [findSimilarButton setImage:[UIImage imageNamed:@"Social-Share"] forState:UIControlStateNormal];
    [findSimilarButton addTarget:self action:@selector(findSimilarAction) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:findSimilarButton];
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
}

-(void)findSimilarAction {
    NSLog(@"Find Similar Action");
}

-(void)inviteTarget:(Gamer *)gamer {
    NSLog(@"Invitation Sent");
    self.gamer.invitationSent = TRUE;
    [self.overView removeFromSuperview];
//    self.view.frame = CGRectMake(0, 0, 320, 1500);
    [scrollView setContentSize:CGSizeMake(320, 2000)];
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
    self.overView.alpha = .8;
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
    self.userInfoView = [[UserInfoView alloc] initWithFrame:CGRectMake(0, 568, 320, 100)];
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
    self.expertInsightsView = [[ExpertInsightView alloc] initWithFrame:CGRectMake(0, self.userInfoView.frame.origin.y + self.userInfoView.frame.size.height, 320, 320)];
    [scrollView addSubview:self.expertInsightsView];
    
    
}

-(void)loadTimeLine {
//    self.timelineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.expertInsightsView.frame.origin.y + self.expertInsightsView.frame.size.height, 320, 320)];
//    [scrollView addSubview:self.timelineView];
    
    TimelineView *timelineView = [[TimelineView alloc] initWithFrame:CGRectMake(0, self.expertInsightsView.frame.origin.y + self.expertInsightsView.frame.size.height, 320, 320)];
    [scrollView addSubview:timelineView];
    
    NSLog(@"Timeline Y: %f", self.timelineView.frame.origin.y);
    
    
//    UILabel *expertLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 206, 21)];
//    expertLabel.text = @"EXPERT INSIGHTS";
//    expertLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0];
//    expertLabel.textColor = [UIColor blackColor];
//    [expertInsightsView addSubview:expertLabel];
    
    TimelineView *timeline = [[TimelineView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    [self.timelineView addSubview:timeline];
}

-(void)loadExpertAppraisal {
    self.expertAppraisalView = [[UIView alloc] initWithFrame:CGRectMake(0, 2000, 320, 320)];
    [scrollView addSubview:self.expertAppraisalView];
    
    NSLog(@"ExpertAppraisal Y: %f", self.expertAppraisalView.frame.origin.y);
    
    //    UILabel *expertLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 206, 21)];
    //    expertLabel.text = @"EXPERT INSIGHTS";
    //    expertLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0];
    //    expertLabel.textColor = [UIColor blackColor];
    //    [expertInsightsView addSubview:expertLabel];
    
    ExpertAppraisalView *expertView = [[ExpertAppraisalView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    [self.timelineView addSubview:expertView];
}


@end
