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

@interface SideViewController ()

@property (nonatomic) ViewController *mainViewController, *topViewController;

@property (nonatomic) BOOL menuButtonBool;
- (IBAction)menuButton:(id)sender;


@end

@implementation SideViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Blank Check Labs";
    self.menuButtonBool = FALSE;
    
    self.mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"mainViewController"];
    [self addChildViewController:self.mainViewController];
    self.mainViewController.view.frame = self.view.frame;
    [self.view addSubview:self.mainViewController.view];
    [self.mainViewController didMoveToParentViewController:self];
    
    self.topViewController = self.mainViewController;
    [self setupPanGesture];
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
    [self.topViewController.view setUserInteractionEnabled:NO];
    [UIView animateWithDuration:.4 animations:^{
        self.topViewController.view.frame = CGRectMake(self.view.frame.size.width * .5, self.topViewController.view.frame.origin.y, self.topViewController.view.frame.size.width, self.topViewController.view.frame.size.height);
    } completion:^(BOOL finished) {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slideBack:)];
        [self.topViewController.view addGestureRecognizer:pan];
    }];
}

- (void)closeMenu
{
    [self.topViewController.view setUserInteractionEnabled:YES];
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
    
    
    if ([segue.identifier isEqualToString:@"search"]) {
        SearchViewController *viewController = segue.destinationViewController;
        viewController.string = @"Boogie Mills";
    }
    
    
    
}

- (IBAction)menuButton:(id)sender {
    if (self.menuButtonBool == FALSE) {
        [self openMenu];
        self.menuButtonBool = TRUE;
    } else {
        [self closeMenu];
        self.menuButtonBool = FALSE;
    }
    
}
@end
