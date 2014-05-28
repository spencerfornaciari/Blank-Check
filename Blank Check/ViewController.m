//
//  ViewController.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 5/15/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "ViewController.h"
#import "NetworkController.h"

@interface ViewController ()

@property (nonatomic) UIWebView *webView;
@property (nonatomic) NSString *authorizationString;
@property (nonatomic) BOOL tokenBOOL;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tokenBOOL = FALSE;
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    self.webView.layer.zPosition = 3;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    self.controller = self.appDelegate.networkController;
    
//    self.urlLabel.text = @"Hello";
    NSString *string = [self.controller beginOAuthAccess];
    
    NSLog(@"url: %@", string);
    
//    NSOperationQueue *queue = [NSOperationQueue new];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSURL *url = [NSURL URLWithString:string];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }];
    
    
//    NSString *url = [self.controller handleCallbackURL:self.authorizationString];

    
    
//    [NetworkController beginOAuthAccess];
	// Do any additional setup after loading the view, typically from a nib.
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
    

//    NSLog(@"TOKEN: %@", url);
//    if ([self.controller convertURLToCode:currentURL]) {
//        NSString *url = [self.controller handleCallbackURL:string];
//        NSLog(@"TOKEN: %@", url);
//    }

}

-(void)newURL
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
