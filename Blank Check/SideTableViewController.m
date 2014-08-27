//
//  SideTableViewController.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/24/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "SideTableViewController.h"
#import "NetworkController.h"
#import "NoteTableViewController.h"
#import "LoginViewController.h"
#import "UIColor+BlankCheckColors.h"
#import "CoreDataHelper.h"
#import "Worker.h"
#import "ProblemView.h"

@interface SideTableViewController ()

@property (nonatomic) UINavigationController *mainViewController, *profileController, *noteNavigationController;

@property (nonatomic) UIViewController *topViewController;

@property (nonatomic) ProblemView *problemView;

@property (nonatomic) BOOL menuOpen;

@property (nonatomic) FeedBrowserTableViewController *controller;
@property (nonatomic) NoteTableViewController *noteController;
@property (nonatomic) DetailScrollViewController *workerView;

@property (nonatomic) Worker *worker;

@end

@implementation SideTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.menuOpen = FALSE;
    
//    self.tableView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0); //values passed are - top, left, bottom, right

    
    self.menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:self action:@selector(menuAction)];
    self.navigationItem.leftBarButtonItem = self.menuButton;
//    [NetworkController sharedController].delegate = self;
    
//    [[NetworkController sharedController] loadUserData];
    
    self.title = @"Blank Check Labs";
//    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 0)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    //Remove cell seperate from last cell
    self.logoutCell.separatorInset = UIEdgeInsetsMake(0, 0, 0, self.logoutCell.bounds.size.width);

    //Instantiate Child View Controller
    self.controller = [self.storyboard instantiateViewControllerWithIdentifier:@"mainViewController"];
    self.controller.delegate = self;
    
    self.mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"mainViewController"];
    [self addChildViewController:self.mainViewController];
    self.mainViewController.view.frame = self.view.frame;
    [self.view addSubview:self.mainViewController.view];
    [self.mainViewController didMoveToParentViewController:self];
    
    self.topViewController = self.mainViewController;
//    [self setupPanGesture];
    
    
    //Worker Profile
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"dataExists"]) {
        self.worker = [CoreDataHelper currentUser];
        self.workerView = [self.storyboard instantiateViewControllerWithIdentifier:@"profileView"];
        self.workerView.detail = self.worker;

//        self.profileController = [[UINavigationController alloc] initWithRootViewController:self.workerView];
        
//        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"]
//                                                                       style:UIBarButtonItemStylePlain
//                                                                      target:self
//                                                                      action:@selector(openMenu)];
//        
//        self.profileController.navigationItem.leftBarButtonItem = menuButton;
        
        [self addChildViewController:self.workerView];
        self.workerView.view.frame = self.view.frame;
        [self.workerView didMoveToParentViewController:self];
        
        //Instantiate Notes Controller
        self.noteController = [self.storyboard instantiateViewControllerWithIdentifier:@"noteController"];
        
        [self addChildViewController:self.noteController];
        self.noteController.view.frame = self.view.frame;
        [self.noteController didMoveToParentViewController:self];
        
//        NSLog(@"Worker: %@ %@", self.worker.firstName, self.worker.lastName);
//        NSLog(@"W Count: %lu", (unsigned long)self.worker.connections.count);
    }
   
   
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"dataExists"]) {
        
        UIImage *image = [UIImage imageWithContentsOfFile:self.worker.imageLocation];
        
        //Set user profile cell link
        self.userCell.imageView.image = image;
        self.userCell.imageView.layer.cornerRadius = 33.0;
        self.userCell.imageView.layer.masksToBounds = TRUE;
        self.userCell.textLabel.text = [NSString stringWithFormat:@"%@ %@", self.worker.firstName, self.worker.lastName];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                            initWithKey:@"date" ascending:NO];
        
        
        self.noteController.noteArray = [[self.worker valueForKey:@"notes"] sortedArrayUsingDescriptors:@[sortDescriptor]];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.tableView reloadData];
            
            self.noteController.noteArray = [[self.worker valueForKey:@"notes"] sortedArrayUsingDescriptors:@[sortDescriptor]];

            [self.noteController.tableView reloadData];
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 7;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        NSLog(@"My profile");
        self.title = @"My Profile";
        self.navigationItem.rightBarButtonItem = nil;

        self.workerView.detail = self.worker;
        self.workerView.view.frame = self.topViewController.view.frame;
        [self.topViewController.view removeFromSuperview];
        self.topViewController = self.workerView;
        [self.view addSubview:self.workerView.view];
//        [self setupPanGesture];
        [self menuAction];

    }
    
    if (indexPath.row == 1) {
        self.title = @"My Feed";
        self.navigationItem.rightBarButtonItem = self.searchButton;
        
        self.mainViewController.view.frame = self.topViewController.view.frame;
        [self.topViewController.view removeFromSuperview];
        self.topViewController = self.mainViewController;
        [self.view addSubview:self.mainViewController.view];
//        [self setupPanGesture];
        
        [self menuAction];

    }
    
//    if (indexPath.row == 2) {
//        NSLog(@"Messages");
//    }
//    if (indexPath.row == 3) {
//        NSLog(@"Notifications");
//    }
    
    if (indexPath.row == 2) {
        NSLog(@"Notes");
        self.title = @"My Notes";
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sort" style:UIBarButtonItemStylePlain target:self action:@selector(sortButtonAction)];
        
        self.noteController.view.frame = self.topViewController.view.frame;
        [self.topViewController.view removeFromSuperview];
        self.topViewController = self.noteController;
        [self.view addSubview:self.noteController.view];
//        [self setupPanGesture];
        
        [self menuAction];
    }
    if (indexPath.row == 3) {
        NSLog(@"Report a Problem");
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Report a Problem" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"General Feedback", @"Flag an Inaccurate Listing", @"Something is Not Working", nil];//[[UIAlertView alloc] initWithFrame:frame];
        [alertView show];
        
//        int size = (self.view.frame.size.height - 110);
//
//        self.problemView = [[ProblemView alloc] initWithFrame:CGRectMake(20, 20, self.view.frame.size.width - 40, size)];
//        [self.problemView.closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
//        
//        [self.tableView addSubview:self.problemView];
    }
    if (indexPath.row == 4) {
        NSLog(@"Terms & Policies");
        
        NSString *terms = @"Disclaimer\nBlank Check Labs (“BCL”) does not guarantee or warrant that the data provided herein is accurate, complete, or current and shall not be liable to you for any loss or injury arising out of or caused in whole or in part by the acts, errors or omissions of BCL, whether negligent or otherwise, in procuring, compiling, gathering, formatting, interpreting, reporting, communicating or delivering the information contained in this mobile application. BCL does not undertake any obligation to update, modify, revise or reorganize the information provided herein, or to notify you or any third party should the information be updated, modified, revised or reorganized. In no event shall BCL be liable to you or any third party for any direct, indirect, incidental, consequential or special damages whether foreseeable or unforeseeable and however caused, even if BCL is advised of the possibility of such damages.\n\nIntellectual Property and Restrictions on Use\nAll materials and resources on this website (the “Resources”), including but not limited to information, documents, products, logos, graphics, sounds, images, software and services, are protected by copyright or other intellectual property laws. Except as stated herein, none of the Resources on this website may be copied, reproduced, distributed, republished, downloaded, displayed, posted or transmitted in any form or by any means, including but not limited to electronic, mechanical, photocopying, recording, or other means, without the prior express written permission of BCL. Users may not modify, copy, distribute, transmit, display, publish, sell, license, create derivative works or otherwise use any information available on this website for any public or commercial purpose. You must have written permission from BCL to distribute copies of the information. Unauthorized use of the Resources may violate copyright, trademark and other intellectual property laws. BCL, the BCL logo, and/or other BCL products referenced herein are trademarks of BCL, and may be registered in certain jurisdictions. All other product names, company names, marks, logos, and symbols may be the trademarks of their respective owners."
        
        ;
//        NSLog(@"String length: %li", terms.length);
//        
//        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:terms];
        
        NSRange firstRegularRange = NSMakeRange(10, 916);
        NSRange secondRegularRange = NSMakeRange(964, 1225);// 2180 //955 //910 //9
        NSRange firstBoldRange = NSMakeRange(0, 10);
        NSRange secondBoldRange = NSMakeRange(917, 47);
//        NSRange secondBoldRange = NSMakeRange(200, 209); // 4 characters, starting at index 22
        
        [string beginEditing];
        
        [string addAttribute:NSFontAttributeName
                       value:[UIFont fontWithName:@"HelveticaNeue" size:11.0]
                       range:firstRegularRange];
        [string addAttribute:NSForegroundColorAttributeName
                       value:[UIColor blackColor]
                       range:firstRegularRange];
        
        [string addAttribute:NSFontAttributeName
                       value:[UIFont fontWithName:@"HelveticaNeue" size:11.0]
                       range:secondRegularRange];
        [string addAttribute:NSForegroundColorAttributeName
                       value:[UIColor blackColor]
                       range:secondRegularRange];
        
        [string addAttribute:NSFontAttributeName
                       value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:11.0]
                       range:firstBoldRange];
        [string addAttribute:NSForegroundColorAttributeName
                       value:[UIColor blackColor]
                       range:firstBoldRange];
        
        [string addAttribute:NSFontAttributeName
                       value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:11.0]
                       range:secondBoldRange];
        [string addAttribute:NSForegroundColorAttributeName
                       value:[UIColor blackColor]
                       range:secondBoldRange];
        
//        [string addAttribute:NSFontAttributeName
//                       value:[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0]
//                       range:secondBoldRange];
//        [string addAttribute:NSForegroundColorAttributeName
//                       value:[UIColor blackColor]
//                       range:secondBoldRange];
        
        [string endEditing];
        
//        NSAttributedString *string = [[NSAttributedString alloc] initWithString:@"Stringy"];

        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Terms & Policies"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"Done"
                                                  otherButtonTitles:nil];
//        alertView.alertViewStyle = UIAlertViewStyleDefault;
        
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 260, 00)];
        textView.scrollEnabled = NO;
        textView.attributedText = string;
        textView.editable = NO;
        textView.backgroundColor = [UIColor clearColor];
        [textView sizeToFit];
        textView.scrollEnabled = YES;
        
//        UIView *viewer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 300)];
////        viewer.backgroundColor = [UIColor yellowColor];
//        
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 260, 300)];
//        label.attributedText = string;
////        [label sizeToFit];
//        label.numberOfLines = 0;
//        
//        [viewer addSubview:label];
        
        
        
        
//        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 60)];
//        v.backgroundColor = [UIColor yellowColor];
        [alertView setValue:textView forKey:@"accessoryView"];

        
//        UITextField *textField = [alertView textFieldAtIndex:0];
//        textField.delegate = self;
//        textField.text = terms;
        [alertView show];
    }
    if (indexPath.row == 5) {
        NSLog(@"Help");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Help" message:@"Help message will go here." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Alternate Button 1", @"Alertnate Button 2", nil];
        [alertView show];
    }
    if (indexPath.row == 6) {
        NSLog(@"Logout");
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"accessToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        LoginViewController *loginView = [LoginViewController new];
        [self presentViewController:loginView animated:YES completion:nil];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

//-(void)willPresentAlertView:(UIAlertView *)alertView {
//        UILabel *title = [alertView valueForKey:@"_titleLabel"];
//        title.font = [UIFont fontWithName:@"Arial" size:18];
//        [title setTextColor:[UIColor whiteColor]];
//         
//        UILabel *body = [alertView valueForKey:@"_bodyTextLabel"];
//        body.font = [UIFont fontWithName:@"Arial" size:15];
//        [body setTextColor:[UIColor whiteColor]];
//}

-(IBAction)closeAction:(id)sender {
    
    if (sender == self.problemView.closeButton) {
        [self.problemView removeFromSuperview];
    }
    
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
    self.title = @"Blank Check Labs";
    [UIView animateWithDuration:.4 animations:^{
        self.topViewController.view.frame = CGRectMake(self.view.frame.size.width, self.topViewController.view.frame.origin.y, self.topViewController.view.frame.size.width, self.topViewController.view.frame.size.height);
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

-(void)menuAction {
    if (self.menuOpen) {
        [self closeMenu];
        self.menuOpen = FALSE;
    } else {
        [self openMenu];
        self.menuOpen = TRUE;

    }
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

-(void)updateUser {
    self.worker = [CoreDataHelper currentUser];
    UIImage *image = [UIImage imageWithContentsOfFile:self.worker.imageLocation];
    
    //Set user profile cell link
    self.userCell.imageView.image = image;
    self.userCell.imageView.layer.cornerRadius = 33.0;
    self.userCell.imageView.layer.masksToBounds = TRUE;
    self.userCell.textLabel.text = [NSString stringWithFormat:@"%@ %@", self.worker.firstName, self.worker.lastName];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.tableView reloadData];
        
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

#pragma mark - Note Action Sheet

-(void)sortButtonAction {
    UIActionSheet *sortActionSheet = [[UIActionSheet alloc] initWithTitle:@"Sort Criteria" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Last Name A-Z", @"Last Name Z-A", @"By Newest", @"By Oldest", nil];
    
    [sortActionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: {
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                                initWithKey:@"connection.lastName" ascending:YES];
            
            self.noteController.noteArray = [[self.worker valueForKey:@"notes"] sortedArrayUsingDescriptors:@[sortDescriptor]];
            [self.noteController.tableView reloadData];
        }
            break;
            
        case 1: {
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                                initWithKey:@"connection.lastName" ascending:NO];
            
            self.noteController.noteArray = [[self.worker valueForKey:@"notes"] sortedArrayUsingDescriptors:@[sortDescriptor]];
            [self.noteController.tableView reloadData];
        }
            break;
            
        case 2: {
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                                initWithKey:@"date" ascending:NO];
            
            self.noteController.noteArray = [[self.worker valueForKey:@"notes"] sortedArrayUsingDescriptors:@[sortDescriptor]];
            [self.noteController.tableView reloadData];
        }
            break;
            
        case 3: {
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                                initWithKey:@"date" ascending:YES];
            
            self.noteController.noteArray = [[self.worker valueForKey:@"notes"] sortedArrayUsingDescriptors:@[sortDescriptor]];
            [self.noteController.tableView reloadData];
        }
            break;
            
        default:
            break;
    }
}

@end
