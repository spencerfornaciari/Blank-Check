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
#import "PauseViewController.h"

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
    
    self.tokenBOOL = FALSE;
    self.gottenUserData = FALSE;
    
    self.webView.delegate = self;
    
    [self newOAuth];
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

//Starts a new login process, in a webview
-(void)newOAuth
{
    NSString *string = [[NetworkController sharedController] beginOAuthAccess];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSURL *url = [NSURL URLWithString:string];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
        
    }];
}

//Handles the web calls during O-Auth process, getting authorization string, access token, then moving on.
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
            NSLog(@"Auth: %@", self.authorizationString);
            NSLog(@"Token: %@", [[NSUserDefaults standardUserDefaults] stringForKey:@"accessToken"]);
            self.tokenBOOL = TRUE;
        }
        
        if (self.tokenBOOL == TRUE) {
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
            SideTableViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier: @"sideView"];
            [self presentViewController:viewController animated:YES completion:nil];
        }
    }
    
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
