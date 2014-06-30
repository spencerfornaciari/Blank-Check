//
//  AppDelegate.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 5/15/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "AppDelegate.h"
#import "SideViewController.h"
#import "LoginViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[UINavigationBar appearance] setBarTintColor:[UIColor blankCheckBlue]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

//    //Create instance of network controller
//    self.networkController = [NetworkController new];
    
    //Create instance of operation queue
    self.blankQueue = [NSOperationQueue new];
    
    //Create instance of Gamer
    self.gamer = [Gamer new];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main_iPhone"
                                                             bundle: nil];

    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"accessToken"]) {
        NSLog(@"No Token");
    } else {
        NSLog(@"Token available");
        
        BOOL tokenIsCurrent = [[NetworkController sharedController] checkTokenIsCurrent];
        
        if (tokenIsCurrent) {
            NSLog(@"Token is current");
            
            SideViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier: @"sideView"];
            self.window.rootViewController = viewController;
            
        } else {
            NSLog(@"Token is NOT current");
            
            LoginViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier: @"loginView"];
            self.window.rootViewController = viewController;
        }
    }
    
    
    return YES;
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSString *string  = [NSString stringWithFormat:@"Callback: %@", url];
    NSLog(@"Callback: %@", string);
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
