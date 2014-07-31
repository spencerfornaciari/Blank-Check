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
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"dataExists"]) {
        [self loadCoreData];
    }
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

    
    
    //Core Data Example
//    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//    NSManagedObjectContext *context = [appDelegate managedObjectContext];
//    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Worker" inManagedObjectContext:context];
//    NSFetchRequest *request = [NSFetchRequest new];
//    [request setEntity:entityDescription];
//    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstName = %@", @"Spencer"];
//    [request setPredicate:predicate];
//    
//    NSManagedObject *matches = nil;
//    
//    NSError *error;
//    
//    NSArray *objects = [context executeFetchRequest:request error:&error];
//    
//    NSLog(@"Objects: %u", (unsigned)objects.count);
//    
//    if ([objects count] == 0) {
//        NSLog(@"No matches");
//    } else {
////        NSLog(@"Found a Jessica");
//        for (int i = 0; i < objects.count; i++) {
//            matches = objects[i];
//            NSLog(@"%@ %@ %@", [matches valueForKey:@"firstName"], [matches valueForKey:@"lastName"], [matches valueForKey:@"location"]);
//            for (Job *unit in [matches valueForKey:@"jobs"]) {
//                NSLog(@"%@", [unit valueForKey:@"companyName"]);
//                //I am not at a computer, so I cannot test, but this should work. You might have to access each property of the unit object to fire the fault, but I don't believe that is necessary.
//            }
////            NSLog(@"Jobs: %@", );
//        }
//    }

    //    [self add];
    
/*
   if ([self doesGamerExist]) {
        self.downloadingUserData = TRUE;
//        self.one = [NSKeyedUnarchiver unarchiveObjectWithFile:[Gamer gamerPath]];
//        
//        self.appDelegate = [[UIApplication sharedApplication] delegate];
//        self.appDelegate.gamer = self.one;
        
        self.feedArray = [NSMutableArray new];
        self.feedArray = self.one.connectionIDArray;
    } else {
        if (!self.one && self.downloadingUserData == FALSE) {
            [self.operationQueue addOperationWithBlock:^{
                self.one = [[NetworkController sharedController] loadCurrentUserData];
                NSLog(@"User Count: %d", self.one.connectionIDArray.count);
                
//                [NSKeyedArchiver archiveRootObject:self.one toFile:[Gamer gamerPath]];
//                
//                self.appDelegate = [[UIApplication sharedApplication] delegate];
//                self.appDelegate.gamer = self.one;
                
                self.feedArray = [NSMutableArray new];
                self.feedArray = self.one.connectionIDArray;
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self.loadingView.activityIndicator stopAnimating];
                    [self.loadingView removeFromSuperview];
                    
                    [self.tableView reloadData];
                }];
            }];
        } else {
            
        }
    }
*/
//    
    
    
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

//-

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
    self.worker = objects[0];

    
}
                       
-(NSString *)documentsDirectoryPath
    {
        NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        return [documentsURL path];
    }
@end
