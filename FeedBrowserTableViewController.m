//
//  FeedBrowserTableViewController.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 6/18/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "FeedBrowserTableViewController.h"
#import "DetailScrollViewController.h"
#import "AppDelegate.h"
#import "FeedTableViewCell.h"
#import "NetworkController.h"
#import "Gamer.h"
#import "LoadingView.h"

@interface FeedBrowserTableViewController ()

@property (nonatomic) Gamer *one, *two, *three;
@property (nonatomic) NSMutableArray *feedArray;

@property (nonatomic) NSOperationQueue *operationQueue;
@property (nonatomic) AppDelegate *appDelegate;

@property (nonatomic) LoadingView *loadingView;

@end

@implementation FeedBrowserTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Blank Check Labs";
    
    self.operationQueue = [(AppDelegate *)[[UIApplication sharedApplication] delegate] blankQueue];
    
    [self.operationQueue addOperationWithBlock:^{
        self.one = [[NetworkController sharedController] loadCurrentUserData];
        
        self.appDelegate = [[UIApplication sharedApplication] delegate];
        self.appDelegate.gamer = self.one;
        
        self.feedArray = [NSMutableArray new];
        self.feedArray = self.one.connectionIDArray;
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.loadingView.activityIndicator stopAnimating];
            [self.loadingView removeFromSuperview];
            
            [self.tableView reloadData];
        }];
    }];
    
//    [self.networkController checkProfileText:@"Film Publicist"];
//    [[NetworkController sharedController] createDictionary];
//    [[NetworkController sharedController] listDictionaries];
//    [[NetworkController sharedController] readDictionaryWithName:@"got"];
//    [[NetworkController sharedController] updateDictionaryWithName:@"got"];
    
//    [self.operationQueue addOperationWithBlock:^{
//        
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            [self.tableView reloadData];
//        }];
//    }];
    
//    [self.networkController loadCurrentUserData:self.one];
    
    
    //    [self.networkController sendInvitationToUserID:self.one.gamerID];
    //    NSArray *array = [self.networkController commonConnectionsWithUser:@"mXtsRDLoyK"];
    //    NSLog(@"%@", array);
    //    NSLog(@"Count: %lu", (unsigned long)array.count);
    

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(160,320,100,100)];
    self.loadingView.center = CGPointMake(self.view.center.x, self.view.center.y - 65);
    self.loadingView.layer.zPosition = 2;
    [self.tableView addSubview:self.loadingView];
    [self.tableView bringSubviewToFront:self.loadingView];

    self.loadingView.activityIndicator.hidesWhenStopped = TRUE;
    self.loadingView.activityIndicator.hidden = FALSE;
    [self.loadingView.activityIndicator startAnimating];
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
    return self.feedArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    Gamer *gamer = self.feedArray[indexPath.row];
    
    [cell setCell:gamer];
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    Gamer *gamer = self.feedArray[indexPath.row];
    
    DetailScrollViewController *viewController = segue.destinationViewController;
    viewController.gamer = gamer;
}

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
