//
//  SViewController.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/3/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "SearchViewController.h"
#import "PresetSearchViewController.h"
#import "DetailScrollViewController.h"
#import "UIColor+BlankCheckColors.h"

@interface SearchViewController ()

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic) NSString *scopeString, *searchString;

@property (nonatomic) PresetSearchViewController *controller;

@property (nonatomic) NSArray *searchResultsArray;

@property (nonatomic) UIView *overView;
@property (nonatomic) Connection *selectedConnection;

@end

@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Search";
    
    self.connectionsArray = [CoreDataHelper fetchUserConnections];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.searchBar.barTintColor = [UIColor blankCheckBlue];
    
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]
                                initWithTitle:@"Home"
                                style:UIBarButtonItemStyleBordered
                                target:self
                                action:nil];
    self.navigationController.navigationBar.topItem.backBarButtonItem=btnBack;
        
    [self loadOverview];

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[[GAIDictionaryBuilder createAppView] set:@"Search View"
                                                      forKey:kGAIScreenName] build]];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return self.searchResultsArray.count;
        
    } else {
        return self.connectionsArray.count;
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        Connection *connection = [self.searchResultsArray objectAtIndex:indexPath.row];
        
        if ([self.scopeString isEqualToString:@"Name"]) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
//                                    reuseIdentifier:@"Cell"];
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", connection.firstName, connection.lastName];
//            cell.detailTextLabel.text = NSString
//
        } else if ([self.scopeString isEqualToString:@"Title"]) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", connection.firstName, connection.lastName];
          
            NSArray *jobArray = [connection.jobs allObjects];
            NSPredicate *jobTitlePredicate = [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@", self.searchString];
            NSArray *titleArray = [jobArray filteredArrayUsingPredicate:jobTitlePredicate];

            cell.detailTextLabel.text = [titleArray[0] title];
        } else if ([self.scopeString isEqualToString:@"Location"]) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", connection.firstName, connection.lastName];
            cell.detailTextLabel.text = connection.location;
        } else {
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", connection.firstName, connection.lastName];
            cell.detailTextLabel.text = @"ALL";
        }
    } else {
        Connection *connection = [self.searchResultsArray objectAtIndex:indexPath.row];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", connection.firstName, connection.lastName];
        cell.detailTextLabel.text = connection.location;
    }
    
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//   
//    if (tableView == self.searchDisplayController.searchResultsTableView) {
//        NSLog(@"Did select");
//        [self performSegueWithIdentifier:@"detailedView" sender:self];
////        [self performSegueWithIdentifier: @"detailedView" sender: self];
//        NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
//        self.selectedConnection =  (Connection *)self.searchResultsArray[indexPath.row];
//        //
////        DetailScrollViewController *detailedView = segue.destinationViewController;
////        detailedView.gamer = gamer;
//    } else {
////       self.selectedConnection = (Connection *)self.connectionsArray[indexPath.row];
//    }
//}
//
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detailedView"]) {
        NSLog(@"Prepare segue");
        
        Connection *connection;
        
        if (self.searchDisplayController.active) {
            NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            
            connection = (Connection *)self.searchResultsArray[indexPath.row];
        } else {
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            
            connection = (Connection *)self.searchResultsArray[indexPath.row];
        }

        DetailScrollViewController *detailedView = segue.destinationViewController;
        detailedView.detail = connection;
        
    }

}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    self.scopeString = scope;
    self.searchString = searchText;
    
    if ([scope isEqualToString:@"Name"]) {
        //Name Predicate
        NSPredicate *firstNamePredicate = [NSPredicate predicateWithFormat:@"firstName BEGINSWITH[cd] %@", searchText];
        NSPredicate *lastNamePredicate = [NSPredicate predicateWithFormat:@"lastName BEGINSWITH[cd] %@", searchText];
        NSPredicate *namePredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[firstNamePredicate, lastNamePredicate]];

        self.searchResultsArray = [self.connectionsArray filteredArrayUsingPredicate:namePredicate];//
        
    } else if ([scope isEqualToString:@"Title"]) {
        //Job Title Predicate
        NSPredicate *jobTitlePredicate = [NSPredicate predicateWithFormat:@"ANY SELF.jobs.title CONTAINS[cd] %@", searchText];
        self.searchResultsArray = [self.connectionsArray filteredArrayUsingPredicate:jobTitlePredicate];
        
    } else if ([scope isEqualToString:@"Location"]) {
        //Location Predicate
        NSPredicate *locationPredicate = [NSPredicate predicateWithFormat:@"location CONTAINS[cd] %@", searchText];
        self.searchResultsArray = [self.connectionsArray filteredArrayUsingPredicate:locationPredicate];
        
    } else {

        
    }
    
}

#pragma mark - UISearchDisplayController delegate methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [self.controller removeFromParentViewController];
    
    return YES;
}

-(void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    searchBar.text = self.searchString;
}
 

-(void)loadOverview {
    self.controller = [self.storyboard instantiateViewControllerWithIdentifier:@"presetSearch"];
    [self addChildViewController:self.controller];
    self.controller.view.frame = CGRectMake(0, 108, 320, 480);
    [self.view addSubview:self.controller.view];
    [self.controller didMoveToParentViewController:self];
}
@end
