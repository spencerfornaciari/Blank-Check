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

@property (nonatomic) NSArray *totalArray, *searchResultsArray;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

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
    self.totalArray = [[NSArray alloc] initWithObjects:@"Tim Cook", @"Jonathan Ive", @"Craig Federighi", @"Angela Ahrendts", @"Eddy Cue", @"Luca Maestri", @"Dan Riccio", @"Philip W. Schiller", @"Bruce Sewell", @"Jeff Williams", nil];
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
    static NSString *simpleTableIdentifier = @"RecipeCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        Gamer *gamer = self.searchArray[indexPath.row];
        cell.textLabel.text = gamer.fullName;
    } else {
        Gamer *gamer = self.searchArray[indexPath.row];
        cell.textLabel.text = gamer.fullName;
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
    
    if ([scope isEqualToString:@"Name"]) {
        NSLog(@"Name");
        //Full Name Predicate
        NSPredicate *fullNamePredicate = [NSPredicate predicateWithFormat:@"fullName CONTAINS[cd] %@", searchText];
        self.searchResultsArray = [self.searchArray filteredArrayUsingPredicate:fullNamePredicate];
    } else if ([scope isEqualToString:@"Title"]) {
        NSLog(@"Title");
        //Job Title Predicate
        NSPredicate *jobTitlePredicate = [NSPredicate predicateWithFormat:@"ANY SELF.currentPositionArray.title CONTAINS[cd] %@", searchText];
        self.searchResultsArray = [NSArray arrayWithArray:[self.searchArray filteredArrayUsingPredicate:jobTitlePredicate]];
        
    } else if ([scope isEqualToString:@"Location"]) {
        NSLog(@"Location");
        //Location Predicate
        NSPredicate *locationPredicate = [NSPredicate predicateWithFormat:@"location CONTAINS[cd] %@", searchText];
        self.searchResultsArray = [NSArray arrayWithArray:[self.searchArray filteredArrayUsingPredicate:locationPredicate]];
    } else {
        NSLog(@"All");
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
