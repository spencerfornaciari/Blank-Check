//
//  LoginViewController.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 6/23/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "LoginViewController.h"
#import "SideViewController.h"
#import "NetworkController.h"

@interface LoginViewController ()

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic) NetworkController *networkController;
@property (nonatomic) NSOperationQueue *operationQueue;

@property (nonatomic) NSString *authorizationString, *accessToken;
@property (nonatomic) BOOL tokenBOOL, tokenStatus, gottenUserData;
@property (nonatomic) Gamer *currentGamer;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.networkController = [(AppDelegate *)[[UIApplication sharedApplication] delegate] networkController];
    self.operationQueue = [(AppDelegate *)[[UIApplication sharedApplication] delegate] blankQueue];
    self.currentGamer = [(AppDelegate *)[[UIApplication sharedApplication] delegate] gamer];
    
    self.tokenBOOL = FALSE;
    self.gottenUserData = FALSE;
    
    [self newOAuth];
    
//    if (tokenIsCurrent) {
//        NSLog(@"Token is current");
//    } else {
//        NSLog(@"Token is NOT current");
//    }
//    NSURL *url = [NSURL URLWithString:<#(NSString *)#>]
//    
//    [self.webView loadRequest:[NSURLRequest requestWithURL:<#(NSURL *)#>]
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)newOAuth
{
    NSString *string = [self.networkController beginOAuthAccess];
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
    
    self.authorizationString = [self.networkController convertURLToCode:currentURL];
    
    if (self.authorizationString && self.tokenBOOL == FALSE) {
        [self.networkController handleCallbackURL:self.authorizationString];
        NSLog(@"Auth: %@", self.authorizationString);
        self.tokenBOOL = TRUE;
    }
    
    
    // Rethink logic here
    if (self.tokenBOOL && self.gottenUserData == FALSE) {
        NSLog(@"We have an auth token");
        self.currentGamer = [self.networkController loadCurrentUserData];
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        SideViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier: @"sideView"];
        
        [self presentViewController:viewController animated:YES completion:nil];
//        self.haveRunJSON = TRUE;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
