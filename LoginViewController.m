//
//  LoginViewController.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 6/23/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "LoginViewController.h"
#import "SideTableViewController.h"
#import "NetworkController.h"

@interface LoginViewController ()

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic) NetworkController *networkController;
@property (nonatomic) NSOperationQueue *operationQueue;

@property (nonatomic) NSString *authorizationString, *accessToken;
@property (nonatomic) BOOL tokenBOOL, tokenStatus, gottenUserData;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.operationQueue = [(AppDelegate *)[[UIApplication sharedApplication] delegate] blankQueue];
//    self.currentGamer = [(AppDelegate *)[[UIApplication sharedApplication] delegate] gamer];
    
    self.tokenBOOL = FALSE;
    self.gottenUserData = FALSE;
    
    self.webView.delegate = self;
    
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
    NSString *string = [[NetworkController sharedController] beginOAuthAccess];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSURL *url = [NSURL URLWithString:string];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
        
    }];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"didFinish: %@; stillLoading:%@", [[webView request]URL],
          (webView.loading?@"NO":@"YES"));
    
    if (webView.isLoading) {
        return;
        
    } else {
        NSURLRequest *currentRequest = [self.webView request];
        NSURL *currentURL = [currentRequest URL];
        
        self.authorizationString = [[NetworkController sharedController] convertURLToCode:currentURL];
        
        NSLog(@"Token BOOL: %d, AuthorizationString: %@", self.tokenBOOL, self.authorizationString);
        
        if (self.authorizationString && self.tokenBOOL == FALSE) {
            [[NetworkController sharedController] handleCallbackURL:self.authorizationString];
//            [self.networkController handleCallbackURL:self.authorizationString];
            NSLog(@"Auth: %@", self.authorizationString);
            NSLog(@"Token: %@", [[NSUserDefaults standardUserDefaults] stringForKey:@"accessToken"]);
            self.tokenBOOL = TRUE;
        }
        
        
        // Rethink logic here
        if (self.tokenBOOL == TRUE) {
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
            SideTableViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier: @"sideView"];
            
            [self presentViewController:viewController animated:YES completion:nil];
        }
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

//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//    NSLog(@"Loading: %@", [request URL]);
//    return YES;
//}
//
//
//
//
//
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
//    NSLog(@"didFail: %@; stillLoading:%@", [[webView request]URL],
//          (webView.loading?@"NO":@"YES"));
//}

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
