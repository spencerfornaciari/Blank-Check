//
//  SViewController.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/3/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "SearchViewController.h"
#import "OldSearchViewController.h"
#import "DetailScrollViewController.h"
#import "UIColor+BlankCheckColors.h"
#import "Gamer.h"

@interface SearchViewController ()

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic) NSString *scopeString;

@property (nonatomic) NSArray *searchResultsArray;

@property (nonatomic) UIView *overView;

@end

@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Search";
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
        Gamer *gamer = self.searchResultsArray[indexPath.row];
        
        if ([self.scopeString isEqualToString:@"Name"]) {
            cell.textLabel.text = gamer.fullName;
//            cell.detailTextLabel.text = @"NAME";
        } else if ([self.scopeString isEqualToString:@"Title"]) {
            cell.textLabel.text = gamer.fullName;
            cell.detailTextLabel.text = [gamer.currentPositionArray[0] title];
        } else if ([self.scopeString isEqualToString:@"Location"]) {
            cell.textLabel.text = gamer.fullName;
            cell.detailTextLabel.text = gamer.location;
        } else {
            cell.textLabel.text = gamer.fullName;
            cell.detailTextLabel.text = @"ALL";
        }
    } else {
        Gamer *gamer = self.connectionsArray[indexPath.row];
        cell.textLabel.text = gamer.fullName;
        cell.detailTextLabel.text = gamer.location;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        NSLog(@"Did select");
//        [self performSegueWithIdentifier: @"detailedView" sender: self];
    }
}
//
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detailedView"]) {
        NSLog(@"Prepare segue");

        NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
        Gamer *gamer =  self.searchResultsArray[indexPath.row];
        NSLog(@"Selected user: %@", gamer.fullName);
//
        DetailScrollViewController *detailedView = segue.destinationViewController;
        detailedView.gamer = gamer;
    }

}

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
        self.searchResultsArray = [self.connectionsArray filteredArrayUsingPredicate:fullNamePredicate];//
        
    } else if ([scope isEqualToString:@"Title"]) {
        //Job Title Predicate
        NSPredicate *jobTitlePredicate = [NSPredicate predicateWithFormat:@"ANY SELF.currentPositionArray.title CONTAINS[cd] %@", searchText];
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
    [self.overView removeFromSuperview];
    
    return YES;
}
 

-(void)loadOverview {
//    self.overView = [[UIView alloc] initWithFrame:CGRectMake(0, 108, 320, self.view.frame.size.height-65)];
//    self.overView.backgroundColor = [UIColor blueColor];
//    self.overView.layer.zPosition = 5;
//    [self.view addSubview:self.overView]
    
//    OldSearchViewController *viewController = [OldSearchViewController new];
//    [self presentViewController:viewController animated:NO completion:nil];
}
@end
