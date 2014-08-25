//
//  ViewController.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 5/15/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "ViewController.h"
#import "NetworkController.h"
#import "PresetSearchViewController.h"
#import "Language.h"

#define TEST_UPDATE FALSE

@interface ViewController ()

@property (nonatomic) UIWebView *webView;
@property (nonatomic) NSString *authorizationString, *accessToken;
@property (nonatomic) BOOL tokenBOOL, tokenStatus, haveRunJSON;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Blank Check";
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.tokenBOOL = FALSE;
    self.haveRunJSON = FALSE;
    
//    self.controller = [(AppDelegate *)[[UIApplication sharedApplication] delegate] networkController];
    
    if (TEST_UPDATE) {
        NSLog(@"Updating Token");
        [self newOAuth];
    } else {
        NSLog(@"Using Existing Token");
        //Check to see if there is an access token already, otherwise get a new one
        if ([[NSUserDefaults standardUserDefaults] stringForKey:@"accessToken"]) {
            self.tokenStatus = [self.controller checkTokenIsCurrent];
            NSLog(@"Boolean status: %d", self.tokenStatus);
            
            //Check to see if existing access token is still valid, otherwise get a new one
            if (self.tokenStatus){
                self.accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"accessToken"];
                
            } else {
                
                [self newOAuth];
            }
        }
        
        else {
            
            [self newOAuth];
        }
    }
    
    //Check to see if there is an access token already, otherwise get a new one
//    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"accessToken"]) {
//        self.tokenStatus = [self.controller checkTokenIsCurrent];
//        NSLog(@"Boolean status: %d", self.tokenStatus);
//        
//        //Check to see if existing access token is still valid, otherwise get a new one
//        if (self.tokenStatus){
//            self.accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"accessToken"];
//            
//            [self testJSON];
//        } else {
//            
//            [self newOAuth];
//        }
//    }
//    
//    else {
//        
//        [self newOAuth];
//    }
    
//    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
//    self.webView.layer.zPosition = 0;
//    self.webView.delegate = self;
//    [self.view addSubview:self.webView];
    

    

    
    
//    NSString *url = [self.controller handleCallbackURL:self.authorizationString];

    
    
//    [NetworkController beginOAuthAccess];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)newOAuth
{
    NSString *string = [self.controller beginOAuthAccess];
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
    
    self.authorizationString = [self.controller convertURLToCode:currentURL];
    
    if (self.authorizationString && self.tokenBOOL == FALSE) {
        [self.controller handleCallbackURL:self.authorizationString];
        NSLog(@"Auth: %@", self.authorizationString);
        self.tokenBOOL = TRUE;
    }
    
    if (self.tokenBOOL && self.haveRunJSON == FALSE) {
        NSLog(@"We have an auth token");
        [self.webView removeFromSuperview];
        self.haveRunJSON = TRUE;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)documentsDirectoryPath
{
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    return [documentsURL path];
}

-(void)buttonPress {
    NSLog(@"Button Press");

   
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}


@end
