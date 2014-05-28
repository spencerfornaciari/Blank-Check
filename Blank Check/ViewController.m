//
//  ViewController.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 5/15/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "ViewController.h"
#import "NetworkController.h"
#import "Gamer.h"

@interface ViewController ()

@property (nonatomic) UIWebView *webView;
@property (nonatomic) NSString *authorizationString;
@property (nonatomic) BOOL tokenBOOL;
@property (nonatomic) Gamer *currentGamer;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tokenBOOL = FALSE;
    
    self.currentGamer = [Gamer new];
    
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"accessToken"]) {
        [self testJSON];
    } else {
        NSString *string = [self.controller beginOAuthAccess];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSURL *url = [NSURL URLWithString:string];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [self.webView loadRequest:request];
        }];
    }
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    self.webView.layer.zPosition = 3;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    self.controller = self.appDelegate.networkController;
    
//    self.urlLabel.text = @"Hello";
    
    
    
//    NSOperationQueue *queue = [NSOperationQueue new];
    

    

    
    
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
    
    if (self.tokenBOOL) {
        
    }
    
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"accessToken"]) {
//        NSString *string = [NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~?oauth2_access_token=%@&%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"accessToken"], @"format=json"];
//        NSLog(@"String: %@", string);
        
    }

//    NSLog(@"Default Access Token: %@", [[NSUserDefaults standardUserDefaults] stringForKey:@"accessToken"]);
//    NSLog(@"TOKEN: %@", url);
//    if ([self.controller convertURLToCode:currentURL]) {
//        NSString *url = [self.controller handleCallbackURL:string];
//        NSLog(@"TOKEN: %@", url);
//    }

}

-(void)testJSON
{
    
    //Generating the NSMutableURLRequest with the base LinkedIN URL with token extension in the HTTP Body
//    NSString *string = [NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~"]
    
    NSURL *url = [NSURL URLWithString:@"https://api.linkedin.com/v1/people/id=kvjFrOuozB:(id,first-name,last-name,industry,headline,num-connections,picture-url,email-address,last-modified-timestamp,interests,languages,skills,certifications,three-current-positions)?oauth2_access_token=AQWlBgoqxdW9OLFOg1UUEGFt_Re-vnQLw7F9lTHXM6QzPBiT0iWzXOQQHP49hfmfm21N2n7LGhAnDRB3tsYdnfoQK9sG8KMDjrVVeTp5Psld5VAkE0ACHcd0MDrdT0_VOfVXLbDIc4wfqL3tlrnvGuqHcs2TeRwxTL4nzL_oVTM8e9NVeE8&format=json"];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                               options:NSJSONReadingMutableLeaves
                                                                 error:nil];
    
    self.currentGamer.firstName = dictionary[@"firstName"];
    self.currentGamer.lastName = dictionary[@"lastName"];
    self.currentGamer.gamerID = dictionary[@"id"];
    self.currentGamer.gamerEmail = dictionary[@"emailAddress"];
    
    NSLog(@"%@", [NSString stringWithFormat:@"%@ %@", self.currentGamer.firstName, self.currentGamer.lastName]);
//    [self.urlLabel setNeedsDisplay];
    
//    NSLog(@"%@",dictionary);

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
