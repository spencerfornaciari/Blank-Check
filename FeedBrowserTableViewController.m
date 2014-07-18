//
//  FeedBrowserTableViewController.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 6/18/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "FeedBrowserTableViewController.h"


@interface FeedBrowserTableViewController ()

@property (nonatomic) Gamer *one, *two, *three;
@property (nonatomic) NSMutableArray *feedArray;

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
    
//    self.controller = [NetworkController new];
//    self.controller.delegate = self;
    [NetworkController sharedController].delegate = self;
    
    self.operationQueue = [(AppDelegate *)[[UIApplication sharedApplication] delegate] blankQueue];
    
    if (!self.one && self.downloadingUserData == FALSE) {
        [self.operationQueue addOperationWithBlock:^{
            [[NetworkController sharedController] loadUserData];

//            self.one = [[NetworkController sharedController] loadCurrentUserData];
//            NSLog(@"User Count: %lu", (unsigned long)self.one.connectionIDArray.count);
//            
//            //                [NSKeyedArchiver archiveRootObject:self.one toFile:[Gamer gamerPath]];
//            //
//            self.appDelegate = [[UIApplication sharedApplication] delegate];
//            self.appDelegate.gamer = self.one;
            
//            self.feedArray = [NSMutableArray new];
//            self.feedArray = self.one.connectionIDArray;
//            
//            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                [self.loadingView.activityIndicator stopAnimating];
//                [self.loadingView removeFromSuperview];
//                
//                [self.tableView reloadData];
//            }];
        }];
    }
    
    //Core Data Example
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Gamer" inManagedObjectContext:context];
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstName = %@", @"Bob"];
    [request setPredicate:predicate];
    
    NSManagedObject *matches = nil;
    
    NSError *error;
    
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    if ([objects count] == 0) {
        NSLog(@"No matches");
    } else {
        NSLog(@"Found a Bob");
        for (int i = 0; i < objects.count; i++) {
            matches = objects[i];
            NSLog(@"%@ %@ %@", [matches valueForKey:@"firstName"], [matches valueForKey:@"lastName"], [matches valueForKey:@"location"]);
        }
    }
    
    [self.controller loadUserData];
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
    NSLog(@"User Count: %lu", (unsigned long)self.one.connectionIDArray.count);

//    NSArray *myArray = [NetworkController grabUserConnections];
//    NSLog(@"Count: %ld", (long)myArray.count);
    
//    [NSKeyedArchiver archiveRootObject:self.one toFile:[Gamer gamerPath]];
    
//    Gamer *gamerNew = [NSKeyedUnarchiver unarchiveObjectWithFile:[Gamer gamerPath]];
//    
//    NSLog(@"Full name: %@", gamerNew.fullName);
//    
//    NSLog(@"Full name: %@", gamerNew.imageLocalLocation);
//    NSLog(@"Connection Count: %lu", (unsigned long)gamerNew.connectionIDArray.count);
    
    
//    if (self.one) {
//        if (!self.seenController.seenArray)
//        {
//            self.seenController.seenArray = [NSMutableArray new];
//        }
//        
//        [self.seenController.seenArray addObject:film];
//        [NSKeyedArchiver archiveRootObject:self.seenController.seenArray toFile:_seenItPath];
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
    

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [Amplitude logEvent:[NSString stringWithFormat:@"Feed Browser - %@", self.one.fullName]];
//    id tracker = [[GAI sharedInstance] defaultTracker];
//    [tracker set:kGAIScreenName value:@"Feed Browser Table"];
//    
//    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
//    [NSKeyedArchiver archiveRootObject:self.one toFile:[Gamer gamerPath]];
    
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
    
    // Configure the cell...
    Gamer *gamer = self.feedArray[indexPath.row];
    
    [cell setCell:gamer];
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"detailedView"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        Gamer *gamer = self.feedArray[indexPath.row];
        
        DetailScrollViewController *viewController = segue.destinationViewController;
        viewController.gamer = gamer;
    }
    
    if ([segue.identifier isEqualToString:@"searchView"]) {
        SearchViewController *viewController = segue.destinationViewController;
        viewController.connectionsArray = self.one.connectionIDArray;
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

-(void)add {
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSManagedObject *newContact;
    newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Gamer" inManagedObjectContext:context];
    [newContact setValue:@"Bob" forKey:@"firstName"];
    [newContact setValue:@"Johnson" forKey:@"lastName"];
    [newContact setValue:@"Seattle" forKey:@"location"];
    
    NSError *error;
    [context save:&error];
    
}

-(void)setGamerData:(Gamer *)gamer {
    self.one = gamer;
    self.feedArray = [NSMutableArray new];
    self.feedArray = self.one.connectionIDArray;
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.loadingView.activityIndicator stopAnimating];
        [self.loadingView removeFromSuperview];
        
        [self.tableView reloadData];
    }];
}
@end
