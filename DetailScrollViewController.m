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

@end

@implementation DetailScrollViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Blank Check Labs";
    
    scrollView.delegate = self;
    
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(320, 1000)];
    
    [self addButtonMenu];
    
    UIImageView *graph = [[UIImageView alloc] initWithFrame:CGRectMake(20, 210, self.view.frame.size.width-40, self.view.frame.size.width-40)];
    graph.backgroundColor = [UIColor blankCheckBlue];
    [scrollView addSubview:graph];
    
    
    //Add UIView over info to promote connection
    UIView *overView = [[UIView alloc] initWithFrame:CGRectMake(20, 210, scrollView.frame.size.width - 40, 1000)];
    overView.backgroundColor = [UIColor blankCheckBlue];
    overView.alpha = 0.7;
    overView.layer.zPosition = 2;
    [scrollView addSubview:overView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, overView.frame.size.width, 40)];
    nameLabel.text = [NSString stringWithFormat:@"%@ has picked up the Blank Check yet.", self.gamer.firstName];
    nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0];
    nameLabel.numberOfLines = 0;
    [nameLabel sizeToFit];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.alpha = 1;
//    CGPoint centerPoint = CGPointMake(overView.center.x, 20);
//    [nameLabel setCenter:centerPoint];
    [overView addSubview:nameLabel];
    
    
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, nameLabel.frame.origin.y + 100, overView.frame.size.width, 60)];
    descriptionLabel.text = @"We provide better estimates when friends use Blank Check.";
    descriptionLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0];
    descriptionLabel.numberOfLines = 0;
    [descriptionLabel sizeToFit];
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    descriptionLabel.textColor = [UIColor whiteColor];
    CGPoint descriptionCenterPoint = CGPointMake(overView.center.x, 200);
    [nameLabel setCenter:descriptionCenterPoint];
    [overView addSubview:descriptionLabel];
    
    NSLog(@"Overview center: %@", NSStringFromCGPoint(overView.center));
    
    UIButton *inviteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    inviteButton.frame = CGRectMake(0, 0, 60, 60);
    inviteButton.center = CGPointMake(overView.center.x, 50);
    [inviteButton setTitle:[NSString stringWithFormat:@"Invite %@", self.gamer.firstName] forState:UIControlStateNormal];
    [inviteButton addTarget:self action:@selector(inviteTarget:) forControlEvents:UIControlEventTouchUpInside];
    [inviteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    inviteButton.backgroundColor = [UIColor whiteColor];
    [overView addSubview:inviteButton];
    
    NSLog(@"Button center: %@", NSStringFromCGPoint(inviteButton.center));
    NSLog(@"Button center: %@", NSStringFromCGPoint(inviteButton.frame.origin));
    
    
    NSString *fullName = [NSString stringWithFormat:@"%@%@", self.gamer.firstName, self.gamer.lastName];
    self.gamer.imageLocalLocation = [NSString stringWithFormat:@"%@/%@.jpg", [self documentsDirectoryPath], fullName];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:self.gamer.imageLocalLocation];
    

    

    
//    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:self.gamer.imageLocalLocation];
//    
//    NSLog(@"File Exists: %d", fileExists);
//    
//    if (fileExists) {
//        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfMappedFile:self.gamer.imageLocalLocation]];
//        
//        profileImage.image = image;
//        [profileImage setNeedsDisplay];
//    } else {
//        NSURL *url = self.gamer.imageURL;
//        NSData *data = [NSData dataWithContentsOfURL:url];
//        UIImage *image = [UIImage imageWithData:data];
//        self.gamer.profileImage = image;
//        [data writeToFile:self.gamer.imageLocalLocation atomically:YES];
//        profileImage.image = self.gamer.profileImage;
//    
//        [profileImage setNeedsDisplay];
//
//    }

    
    profileImage.image = self.gamer.profileImage;
    profileImage.layer.cornerRadius = 60.f;
    profileImage.layer.masksToBounds = TRUE;
    
    NSString *firstLetter = [self.gamer.lastName substringWithRange:NSMakeRange(0, 1)];
    
    userNameLabel.text = [NSString stringWithFormat:@"%@ %@.", self.gamer.firstName, firstLetter];
    
    valueLabel.text = [NSString stringWithFormat:@"$%@", [self.gamer.valueArray lastObject]];
    
    workExpLabel.text = [NSString stringWithFormat:@"Work Exp: Top 10%%"];
    educationExpLabel.text = [NSString stringWithFormat:@"Education Exp: Top 5%%"];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    profileImage.image = [UIImage imageNamed:@"default-user"];
    
    NSURL *url = self.gamer.imageURL;
    
    //    profileImage.backgroundColor = [UIColor blackColor];
    
    if (url) {
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        self.gamer.profileImage = image;
        //
        [data writeToFile:self.gamer.imageLocalLocation atomically:YES];
        profileImage.image = self.gamer.profileImage;
        [profileImage setNeedsDisplay];
    }
    
    //        NSLog(@"False");
    //
    //        UIImage *image2 = [UIImage imageNamed:@"default-user"];
    //
    //        if (image2) {
    //            NSLog(@"True");
    //        }
    //
    //        [profileImage setImage:image2];
    //        
    ////        [profileImage setNeedsDisplay];
    //    }
    
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
    NSLog(@"Invite Action");
}

- (NSString *)documentsDirectoryPath
{
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    return [documentsURL path];
}


@end
