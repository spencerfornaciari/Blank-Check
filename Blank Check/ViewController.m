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

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    self.webView.layer.zPosition = 3;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    self.controller = self.appDelegate.networkController;
    
    self.urlLabel.text = @"Hello";
    NSString *string = [self.controller beginOAuthAccess];
    
    NSLog(@"url: %@", string);
    
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    

    
    
//    [NetworkController beginOAuthAccess];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSURLRequest *currentRequest = [self.webView request];
    NSURL *currentURL = [currentRequest URL];
    NSLog(@"Current URL is %@", currentURL.absoluteString);
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
