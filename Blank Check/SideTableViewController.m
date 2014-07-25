//
//  SideTableViewController.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/24/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "SideTableViewController.h"
#import "UIColor+BlankCheckColors.h"
#import "CoreDataHelper.h"
#import "Worker.h"
#import "ProblemView.h"

@interface SideTableViewController ()

@property (nonatomic) UINavigationController *mainViewController, *topViewController;

@property (nonatomic) ProblemView *problemView;

@property (nonatomic) FeedBrowserTableViewController *controller;

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
    self.title = @"Blank Check Labs";
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 20)];

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Worker" inManagedObjectContext:[CoreDataHelper managedContext]];
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:entity];
    
    NSError *error;
    NSArray *array = [[CoreDataHelper managedContext] executeFetchRequest:request error:&error];
    Worker *worker = array[0];
    
    UIImage *image = [UIImage imageWithContentsOfFile:worker.imageLocation];
    
    //Set user profile cell link
    self.userCell.imageView.image = image;
    self.userCell.imageView.layer.cornerRadius = 33.0;
    self.userCell.imageView.layer.masksToBounds = TRUE;
    self.userCell.textLabel.text = [NSString stringWithFormat:@"%@ %@", worker.firstName, worker.lastName];
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
    return 8;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        NSLog(@"My profile");
//        DetailScrollViewController *detailedView = segue.destinationViewController;
//        detailedView = gamer;

    }
    if (indexPath.row == 1) {
        NSLog(@"Messages");
    }
    if (indexPath.row == 2) {
        NSLog(@"Notifications");
    }
    if (indexPath.row == 3) {
        NSLog(@"Notes");
    }
    if (indexPath.row == 4) {
        NSLog(@"Report a Problem");
        
        int size = (self.view.frame.size.height - 40);

        self.problemView = [[ProblemView alloc] initWithFrame:CGRectMake(20, 20, self.view.frame.size.width - 40, size)];
        [self.problemView.closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.tableView addSubview:self.problemView];
    }
    if (indexPath.row == 5) {
        NSLog(@"Terms & Policies");
    }
    if (indexPath.row == 6) {
        NSLog(@"Help");
    }
    if (indexPath.row == 7) {
        NSLog(@"Logout");
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(IBAction)closeAction:(id)sender {
    [self.problemView removeFromSuperview];
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
