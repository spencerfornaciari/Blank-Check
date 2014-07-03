//
//  SViewController.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/3/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "SearchViewController.h"
#import "UIColor+BlankCheckColors.h"
#import "Gamer.h"

@interface SearchViewController ()

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic) NSString *scopeString;

@property (nonatomic) NSArray *searchResultsArray;

@end

@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Search";
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.searchBar.barTintColor = [UIColor blankCheckBlue];
    
    NSLog(@"Count: %ld", (long)self.searchArray.count);
	// Initialize table data
//    self.totalArray = [[NSArray alloc] initWithObjects:@"Tim Cook", @"Jonathan Ive", @"Craig Federighi", @"Angela Ahrendts", @"Eddy Cue", @"Luca Maestri", @"Dan Riccio", @"Philip W. Schiller", @"Bruce Sewell", @"Jeff Williams", nil];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return self.searchResultsArray.count;
        
    } else {
        return self.searchArray.count;
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        Gamer *gamer = self.searchResultsArray[indexPath.row];
        
        if ([self.scopeString isEqualToString:@"Name"]) {
            cell.textLabel.text = gamer.fullName;
            cell.detailTextLabel.text = @"NAME";
        } else if ([self.scopeString isEqualToString:@"Title"]) {
            cell.textLabel.text = gamer.fullName;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [gamer.currentPositionArray[0] title]];
        } else if ([self.scopeString isEqualToString:@"Location"]) {
            cell.textLabel.text = gamer.fullName;
            cell.detailTextLabel.text = gamer.location;
        } else {
            cell.textLabel.text = gamer.fullName;
            cell.detailTextLabel.text = @"ALL";
        }
        
        cell.textLabel.text = gamer.fullName;
        cell.detailTextLabel.text = gamer.location;
    } else {
        Gamer *gamer = self.searchArray[indexPath.row];
        cell.textLabel.text = gamer.fullName;
        cell.detailTextLabel.text = gamer.location;
    }
    
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (tableView == self.searchDisplayController.searchResultsTableView) {
//        [self performSegueWithIdentifier: @"showRecipeDetail" sender: self];
//    }
//}
//
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"showRecipeDetail"]) {
//        RecipeDetailViewController *destViewController = segue.destinationViewController;
//
//        NSIndexPath *indexPath = nil;
//        if ([self.searchDisplayController isActive]) {
//            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
//            destViewController.recipeName = [searchResults objectAtIndex:indexPath.row];
//
//        } else {
//            indexPath = [self.tableView indexPathForSelectedRow];
//            destViewController.recipeName = [recipes objectAtIndex:indexPath.row];
//        }
//    }
//
//}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
//    NSPredicate *resultPredicate = [NSPredicate
//                                    predicateWithFormat:@"SELF contains[cd] %@",
//                                    searchText];
//    
//    NSLog(@"%@", [self.searchArray filteredArrayUsingPredicate:resultPredicate]);
    self.scopeString = scope;
    
    if ([scope isEqualToString:@"Name"]) {
        //Full Name Predicate
        NSPredicate *fullNamePredicate = [NSPredicate predicateWithFormat:@"fullName CONTAINS[cd] %@", searchText];
        self.searchResultsArray = [self.searchArray filteredArrayUsingPredicate:fullNamePredicate];//
        
    } else if ([scope isEqualToString:@"Title"]) {
        //Job Title Predicate
        NSPredicate *jobTitlePredicate = [NSPredicate predicateWithFormat:@"ANY SELF.currentPositionArray.title CONTAINS[cd] %@", searchText];
        self.searchResultsArray = [NSArray arrayWithArray:[self.searchArray filteredArrayUsingPredicate:jobTitlePredicate]];
        
//        for (Gamer *gamer in self.searchResultsArray) {
//            NSLog(@"%@: %@", gamer.fullName, gamer.currentPositionArray;
//        }
        
    } else if ([scope isEqualToString:@"Location"]) {
        //Location Predicate
        NSPredicate *locationPredicate = [NSPredicate predicateWithFormat:@"location CONTAINS[cd] %@", searchText];
        self.searchResultsArray = [NSArray arrayWithArray:[self.searchArray filteredArrayUsingPredicate:locationPredicate]];
        
        for (Gamer *gamer in self.searchResultsArray) {
            NSLog(@"%@: %@", gamer.fullName, gamer.location);
        }
    } else {

    }
    
//    self.searchResultsArray = [self.totalArray filteredArrayUsingPredicate:resultPredicate];
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
@end
