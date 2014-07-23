//
//  SideViewController.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 6/4/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "SideViewController.h"
#import "SearchViewController.h"
#import "AppDelegate.h"
#import "Worker.h"

@interface SideViewController ()

//@property (nonatomic) ViewController *mainViewController, *topViewController;
@property (nonatomic) UINavigationController *mainViewController, *topViewController;

@property (nonatomic) FeedBrowserTableViewController *controller;

@end

@implementation SideViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Blank Check Labs";
    self.view.backgroundColor = [UIColor blankCheckBrown];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Worker" inManagedObjectContext:[CoreDataHelper managedContext]];
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:entity];
    
    NSError *error;
    NSArray *array = [[CoreDataHelper managedContext] executeFetchRequest:request error:&error];
    Worker *worker = array[0];
    
    UIImage *image = [UIImage imageWithContentsOfFile:worker.imageLocation];
    
    UIButton *userProfileButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    userProfileButton.backgroundColor = [UIColor magentaColor];
    userProfileButton.frame = CGRectMake(0, 40, 320, 80);
    [userProfileButton setTitle:@"Spencer Fornaciari" forState:UIControlStateNormal];
    [userProfileButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -140, 0, 0)];
    userProfileButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0];
    
    
    [userProfileButton setImage:image forState:UIControlStateNormal];
    [userProfileButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 240)];
    userProfileButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    userProfileButton.imageView.layer.cornerRadius = 40;
    userProfileButton.imageView.layer.masksToBounds = true;
    [self.view addSubview:userProfileButton];

    self.controller = [self.storyboard instantiateViewControllerWithIdentifier:@"mainViewController"];
    self.controller.delegate = self;
    
    self.mainViewController = [[UINavigationController alloc] initWithRootViewController:self.controller];
    [self addChildViewController:self.mainViewController];
    self.mainViewController.view.frame = self.view.frame;
    [self.view addSubview:self.mainViewController.view];
    [self.mainViewController didMoveToParentViewController:self];
    
    self.topViewController = self.mainViewController;
    [self setupPanGesture];

//    self.mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"mainViewController"];
//    [self addChildViewController:self.mainViewController];
//    self.mainViewController.view.frame = self.view.frame;
//    [self.view addSubview:self.mainViewController.view];
//    [self.mainViewController didMoveToParentViewController:self];
    
    // Do any additional setup after loading the view.
}

-(void)setupPanGesture
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slidePanel:)];
    
    pan.minimumNumberOfTouches = 1;
    pan.maximumNumberOfTouches = 1;
    
    pan.delegate = self;
    pan.delaysTouchesBegan = NO;
    pan.delaysTouchesEnded = NO;
    
    [self.view addGestureRecognizer:pan];
}

-(void)slidePanel:(id)sender
{
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)sender;
    
    CGPoint translation = [pan translationInView:self.view];
    
    if (pan.state == UIGestureRecognizerStateChanged)
    {
        if (self.topViewController.view.frame.origin.x+ translation.x > 0) {
            
            self.topViewController.view.center = CGPointMake(self.topViewController.view.center.x +translation.x, self.topViewController.view.center.y);
            
            [(UIPanGestureRecognizer *)sender setTranslation:CGPointMake(0,0) inView:self.view];
        }
        
    }
    
    if (pan.state == UIGestureRecognizerStateEnded)
    {
        if (self.topViewController.view.frame.origin.x > self.view.frame.size.width / 2)
        {
            [self openMenu];
        }
        if (self.topViewController.view.frame.origin.x < self.view.frame.size.width / 2 )
        {
            [self closeMenu];
        }
    }
    
}

- (void)openMenu
{
    [UIView animateWithDuration:.4 animations:^{
        self.topViewController.view.frame = CGRectMake(self.view.frame.size.width * .8, self.topViewController.view.frame.origin.y, self.topViewController.view.frame.size.width, self.topViewController.view.frame.size.height);
    } completion:^(BOOL finished) {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slideBack:)];
        [self.topViewController.view addGestureRecognizer:pan];
    }];
}

- (void)closeMenu
{
    [UIView animateWithDuration:.4 animations:
     ^{
         //self.repoViewController.view.frame = CGRectMake(self.repoViewController.view.frame.origin.x, self.self.repoViewController.view.frame.origin.y, self.repoViewController.view.frame.size.width, self.repoViewController.view.frame.size.height);
         
         self.topViewController.view.frame = self.view.frame;
     } completion:^(BOOL finished) {
     }];
}

-(void)slideBack:(id)sender
{
    [UIView animateWithDuration:.4 animations:^{
        self.topViewController.view.frame = self.view.frame;
        [self.topViewController.view removeGestureRecognizer:(UITapGestureRecognizer *)sender];
        [self closeMenu];
    } completion:^(BOOL finished) {
        
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
}

@end
