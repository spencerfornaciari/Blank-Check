//
//  SideTableViewController.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/24/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "SideTableViewController.h"
#import "NetworkController.h"
#import "LoginViewController.h"
#import "UIColor+BlankCheckColors.h"
#import "CoreDataHelper.h"
#import "Worker.h"
#import "ProblemView.h"
#import "NoteView.h"

@interface SideTableViewController ()

@property (nonatomic) UINavigationController *mainViewController, *topViewController, *profileController;

@property (nonatomic) ProblemView *problemView;
@property (nonatomic) NoteView *noteView;

@property (nonatomic) FeedBrowserTableViewController *controller;
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
//    [NetworkController sharedController].delegate = self;
    
//    [[NetworkController sharedController] loadUserData];
    
    self.title = @"Blank Check Labs";
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 20)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    //Remove cell seperate from last cell
    self.logoutCell.separatorInset = UIEdgeInsetsMake(0, 0, 0, self.logoutCell.bounds.size.width);

    //Instantiate Child View Controller
    self.controller = [self.storyboard instantiateViewControllerWithIdentifier:@"mainViewController"];
    self.controller.delegate = self;
    
    self.mainViewController = [[UINavigationController alloc] initWithRootViewController:self.controller];
    [self addChildViewController:self.mainViewController];
    self.mainViewController.view.frame = self.view.frame;
    [self.view addSubview:self.mainViewController.view];
    [self.mainViewController didMoveToParentViewController:self];
    
    self.topViewController = self.mainViewController;
    [self setupPanGesture];
    
    
    //Worker Profile
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"dataExists"]) {
        self.worker = [CoreDataHelper currentUser];
        self.workerView = [self.storyboard instantiateViewControllerWithIdentifier:@"profileView"];
        self.workerView.detail = self.worker;

        self.profileController = [[UINavigationController alloc] initWithRootViewController:self.workerView];
        
//        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"]
//                                                                       style:UIBarButtonItemStylePlain
//                                                                      target:self
//                                                                      action:@selector(openMenu)];
//        
//        self.profileController.navigationItem.leftBarButtonItem = menuButton;
        
        [self addChildViewController:self.profileController];
        self.profileController.view.frame = self.view.frame;
        [self.profileController didMoveToParentViewController:self];
        
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
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.tableView reloadData];
            
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
    return 9;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        NSLog(@"My profile");
        self.profileController.view.frame = self.topViewController.view.frame;
        [self.topViewController.view removeFromSuperview];
        self.topViewController = self.profileController;
        [self.view addSubview:self.profileController.view];
        [self setupPanGesture];

    }
    
    if (indexPath.row == 1) {
        self.mainViewController.view.frame = self.topViewController.view.frame;
        [self.topViewController.view removeFromSuperview];
        self.topViewController = self.mainViewController;
        [self.view addSubview:self.mainViewController.view];
        [self setupPanGesture];
    }
    
    if (indexPath.row == 2) {
        NSLog(@"Messages");
    }
    if (indexPath.row == 3) {
        NSLog(@"Notifications");
    }
    if (indexPath.row == 4) {
        NSLog(@"Notes");
        
        int size = (self.view.frame.size.height - 40);
        
        self.noteView = [[NoteView alloc] initWithFrame:CGRectMake(20, 20, self.view.frame.size.width - 40, size)];
        [self.noteView.closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.tableView addSubview:self.noteView];
        
//        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
//                                            initWithKey:@"date" ascending:YES];
//        NSArray *array = [[self.worker valueForKey:@"notes"] sortedArrayUsingDescriptors:@[sortDescriptor]];
//        
//        self.worker.connections value
//        
        NSLog(@"Notes Count: %li", (unsigned long)self.worker.notes.count);
        //TableView Controller
        //Notes Needs
        //Connection name/id
        //Note Text
        //Note Date
    }
    if (indexPath.row == 5) {
        NSLog(@"Report a Problem");
        
        int size = (self.view.frame.size.height - 40);

        self.problemView = [[ProblemView alloc] initWithFrame:CGRectMake(20, 20, self.view.frame.size.width - 40, size)];
        [self.problemView.closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.tableView addSubview:self.problemView];
    }
    if (indexPath.row == 6) {
        NSLog(@"Terms & Policies");
    }
    if (indexPath.row == 7) {
        NSLog(@"Help");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Help" message:@"Help message will go here." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Alternate Button 1", @"Alertnate Button 2", nil];
        [alertView show];
    }
    if (indexPath.row == 8) {
        NSLog(@"Logout");
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"accessToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        LoginViewController *loginView = [LoginViewController new];
        [self presentViewController:loginView animated:YES completion:nil];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(IBAction)closeAction:(id)sender {
    
    if (sender == self.problemView.closeButton) {
        [self.problemView removeFromSuperview];
    }
    
    if (sender == self.noteView.closeButton) {
        [self.noteView removeFromSuperview];
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
    [UIView animateWithDuration:.4 animations:^{
        self.topViewController.view.frame = CGRectMake(self.view.frame.size.width * .8, self.topViewController.view.frame.origin.y, self.topViewController.view.frame.size.width, self.topViewController.view.frame.size.height);
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

}


@end
