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

//Generates the cell information based on the scope that has been selected
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        Connection *connection = [self.searchResultsArray objectAtIndex:indexPath.row];
        
        if ([self.scopeString isEqualToString:@"Name"]) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", connection.firstName, connection.lastName];
            
            Job *job = [connection.jobs firstObject];
            cell.detailTextLabel.text = job.title;
        } else if ([self.scopeString isEqualToString:@"Title"]) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", connection.firstName, connection.lastName];
          
            NSArray *jobArray = [connection.jobs array];
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

//Filters connections list based on the criteria from the selected scope
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

//Displaying search controller when user selects it
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
 
//Loads the preset search controller on top when the user first enters the search window
-(void)loadOverview {
    self.controller = [self.storyboard instantiateViewControllerWithIdentifier:@"presetSearch"];
    [self addChildViewController:self.controller];
    self.controller.view.frame = CGRectMake(0, 108, 320, self.view.frame.size.height - 90);
    [self.view addSubview:self.controller.view];
    [self.controller didMoveToParentViewController:self];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    self.searchResultsArray = self.connectionsArray;
    [self loadOverview];
}
@end
