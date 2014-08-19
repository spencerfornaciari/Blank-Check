//
//  FeedBrowserTableViewController.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 6/18/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "FeedBrowserTableViewController.h"


@interface FeedBrowserTableViewController ()

@property (nonatomic) Worker *worker;
@property (nonatomic) NSArray *feedArray;


@property (nonatomic) NSOperationQueue *operationQueue;
@property (nonatomic) AppDelegate *appDelegate;

@property (nonatomic) LoadingView *loadingView;

@property (nonatomic) BOOL downloadingUserData, menuButtonBool;
@property (nonatomic) NetworkController *controller;

@end

@implementation FeedBrowserTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Blank Check Labs";
    
    self.menuButtonBool = FALSE;
    self.downloadingUserData = FALSE;
    
    self.operationQueue = [(AppDelegate *)[[UIApplication sharedApplication] delegate] blankQueue];
    [NetworkController sharedController].delegate = self;
//    [[NetworkController sharedController] loadUserData];

//    NSURL *storeURL = [[NSURL URLWithString:[self documentsDirectoryPath]] URLByAppendingPathComponent:@"CoreData.sqlite"];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
    
//    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"dataExists"]) {
        [self loadCoreData];
    }
    
//    float startingPoint = 50000;
//    
//    for (int i = 0; i < 5; i++) {
//        float change = [self randomFloatBetween:.25 and:1.75];
//        NSLog(@"Change: %f", change);
//        startingPoint = startingPoint * (1 - (change/100));
//        NSLog(@"Floating %i: %f", i, startingPoint);
//    }
//    
//    NSLog(@"Random: %f", [self randomFloatBetween:.25 and:1.75]);
    
//    [SocialHelper sendInvitationToUserID:self.worker];
//    } else {
//        if (self.downloadingUserData == FALSE) { //Need to check if DB exists
//            [self.operationQueue addOperationWithBlock:^{
//
////                [[NetworkController sharedController] loadUserData];
//
//            }];
//        }
//
//    }
}



-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[[GAIDictionaryBuilder createAppView] set:@"Feed View"
                                                      forKey:kGAIScreenName] build]];
    
    if (!self.downloadingUserData) {
        self.downloadingUserData = TRUE;
        self.loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(160,320,100,100)];
        self.loadingView.center = CGPointMake(self.view.center.x, self.view.center.y - 65);
        self.loadingView.layer.zPosition = 2;
        [self.tableView addSubview:self.loadingView];
        [self.tableView bringSubviewToFront:self.loadingView];
        
        self.loadingView.activityIndicator.hidesWhenStopped = TRUE;
        self.loadingView.activityIndicator.hidden = FALSE;
        [self.loadingView.activityIndicator startAnimating];
    } else {
        
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
    return self.feedArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Connection *connection = [self.feedArray objectAtIndex:indexPath.row];
    [cell setCell:connection];
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"detailedView"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        DetailScrollViewController *viewController = segue.destinationViewController;
        viewController.detail = [self.feedArray objectAtIndex:indexPath.row];
    }
    
    if ([segue.identifier isEqualToString:@"searchView"]) {
        SearchViewController *viewController = segue.destinationViewController;
        viewController.connectionsArray = self.feedArray;
    }
    
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

-(BOOL)doesGamerExist
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[Gamer gamerPath]]) {
        return FALSE;
    } else {
        return TRUE;
    }
}

- (IBAction)handleMenuButton:(id)sender {
    
    if (self.menuButtonBool == FALSE) {
        [self.delegate openMenu];
        self.menuButtonBool = TRUE;
    } else {
        [self.delegate closeMenu];
        self.menuButtonBool = FALSE;
    }

}

-(void)setGamerData {
    self.feedArray = [NSMutableArray new];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"dataExists"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Worker" inManagedObjectContext:[CoreDataHelper managedContext]];
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:entityDesc];
    
    NSError *error;
    NSArray *objects = [[CoreDataHelper managedContext] executeFetchRequest:request error:&error];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"lastName" ascending:YES];
    self.worker = objects[0];
    
    self.feedArray = [[objects[0] valueForKey:@"connections"] sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self endIndicator];
        [self.delegate updateUser];

        [self.tableView reloadData];
    }];
}

-(void)endIndicator {
    
    [self.loadingView.activityIndicator stopAnimating];
    [self.loadingView removeFromSuperview];
}

//-(void)loadData {
//    self.feedArray = [NSMutableArray new];
//
//    self.feedArray = [self loadCoreDataToTable];
//
//    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//        [self.loadingView.activityIndicator stopAnimating];
//        [self.loadingView removeFromSuperview];
//
//        [self.tableView reloadData];
//    }];
//}

-(NSArray *)loadCoreDataToTable {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"dataExists"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Worker" inManagedObjectContext:[CoreDataHelper managedContext]];
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:entityDesc];
    
    NSError *error;
    NSArray *objects = [[CoreDataHelper managedContext] executeFetchRequest:request error:&error];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"lastName" ascending:YES];
    self.worker = objects[0];
    
    
    return [[objects[0] valueForKey:@"connections"] sortedArrayUsingDescriptors:@[sortDescriptor]];
}

-(void)loadCoreData {
    self.feedArray = [NSMutableArray new];
    self.downloadingUserData = TRUE;
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Worker" inManagedObjectContext:[CoreDataHelper managedContext]];
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:entityDesc];
    
    NSError *error;
    NSArray *objects = [[CoreDataHelper managedContext] executeFetchRequest:request error:&error];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"lastName" ascending:YES];
    self.feedArray = [[objects[0] valueForKey:@"connections"] sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    NSLog(@"Connection Count: %lu", (unsigned long)self.feedArray.count);

    self.worker = objects[0];
    
    NSArray *array = [CoreDataHelper fetchUserConnections];
    NSLog(@"Array Connection Count: %lu", (unsigned long)array.count);

    
}
                       
-(NSString *)documentsDirectoryPath
    {
        NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        return [documentsURL path];
    }
@end
