//
//  SearchViewController.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 6/3/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "PresetSearchViewController.h"
#import "PresetViewController.h"
#import "PresetSearchResultsTableViewController.h"
#import "UIColor+BlankCheckColors.h"

@interface PresetSearchViewController ()

@end

@implementation PresetSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Search";
    self.presetTableView.dataSource = self;
    self.presetTableView.delegate = self;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.searchSegmentController.selectedSegmentIndex = 0;
    
    self.peopleArray = [NSArray arrayWithObjects:@"Steve Ballmer", @"Mark Zuckerberg", @"Tom Brady", @"Martha Steward", @"Brad Pitt", @"Oprah Winfrey", @"Beyonce Knowles", @"Lebron James", @"Kobe Bryant", @"Someone Else", nil];
//    
//    SOFTWARE ENGINEER, SOFTWARE DEVELOPER, BUSINESS ANALYST, SENIOR CONSULTANT, CONSULTANT, SENIOR SOFTWARE ENGINEER, PROJECT MANAGER, DATABASE ADMINISTRATOR, ASSISTANT PROFESSOR, WEB DEVELOPER, MECHANICAL ENGINEER, ACCOUNTANT, FINANCIAL ANALYST, POSTDOCTORAL FELLOW, INDUSTRIAL DESIGNER, MARKET RESEARCH ANALYST, PHYSICIAN, PRODUCT MANAGER, OTHER
    
    self.titleArray = [NSArray arrayWithObjects:@"Software Engineer", @"Software Developer", @"Business Analyst", @"Senior Consultants", @"Consultant", @"Senior Software Engineer", @"Project Manager", @"Database Administrator", @"Assistant Professor", @"Web Developer", @"Mechanical Engineer", @"Accountant", @"Financial Analyst", @"Postdoctoral Fellow", @"Industrial Designer", @"Market Research Analyst", @"Physician", @"Product Manager", @"Self", nil];
    
    self.locationArray = [NSArray arrayWithObjects:@"Seattle", @"Los Angeles", @"New York", @"Chicago", @"Phoenix", @"Las Vegas", @"San Francisco", @"Austin", @"Washington DC", @"Boston", nil];
    
    self.listArray = self.peopleArray;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (self.searchSegmentController.selectedSegmentIndex == 0) {
        NSLog(@"People");
    } else if (self.searchSegmentController.selectedSegmentIndex == 1){
        NSLog(@"Titles");
    } else {
        NSLog(@"Locations");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld. %@", (long)indexPath.row + 1, self.listArray[indexPath.row]];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.listArray.count;
}

- (IBAction)changeSegment:(id)sender {
    if (self.searchSegmentController.selectedSegmentIndex == 0) {
        self.listArray = self.peopleArray;
        [self.presetTableView reloadData];

    } else if (self.searchSegmentController.selectedSegmentIndex == 1){
        
        self.listArray = self.titleArray;
        [self.presetTableView reloadData];
    } else {
         self.listArray = self.locationArray;
        [self.presetTableView reloadData];

    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchSegmentController.selectedSegmentIndex == 0) {
        [self performSegueWithIdentifier:@"presetView" sender:self];
    }  else {
        [self performSegueWithIdentifier:@"resultsTable" sender:self];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"presetView"]) {
        NSIndexPath *indexPath = [self.presetTableView indexPathForSelectedRow];
        PresetViewController *preset = segue.destinationViewController;
        preset.pageTitle = self.listArray[indexPath.row];
        preset.category = @"Person";
    } else {
        if (self.searchSegmentController.selectedSegmentIndex == 1) {
            NSIndexPath *indexPath = [self.presetTableView indexPathForSelectedRow];
            
            PresetSearchResultsTableViewController *preset = segue.destinationViewController;
            NSPredicate *jobTitlePredicate = [NSPredicate predicateWithFormat:@"ANY SELF.jobs.title CONTAINS[cd] %@", self.listArray[indexPath.row]];
            preset.results = [[CoreDataHelper fetchUserConnections] filteredArrayUsingPredicate:jobTitlePredicate];
            preset.title = self.listArray[indexPath.row];
        } else {
            NSIndexPath *indexPath = [self.presetTableView indexPathForSelectedRow];
            
            PresetSearchResultsTableViewController *preset = segue.destinationViewController;
            NSPredicate *locationPredicate = [NSPredicate predicateWithFormat:@"location CONTAINS[cd] %@", self.listArray[indexPath.row]];
            preset.results = [[CoreDataHelper fetchUserConnections] filteredArrayUsingPredicate:locationPredicate];
            preset.title = self.listArray[indexPath.row];
        }
        
        

        
//                preset.pageTitle = self.listArray[indexPath.row];
//        preset.category = @"Person";
    }
//    if (self.searchSegmentController.selectedSegmentIndex == 0) {
//        
//    } else if (self.searchSegmentController.selectedSegmentIndex == 1) {
//        NSLog(@"Segment Controller #2");
//        NSIndexPath *indexPath = [self.presetTableView indexPathForSelectedRow];
//        [NetworkController checkProfileText:self.titleArray[indexPath.row]];
//    } else {
////        if ([segue.identifier isEqualToString:@"presetView"]) {
////            NSIndexPath *indexPath = [self.presetTableView indexPathForSelectedRow];
////            PresetViewController *preset = segue.destinationViewController;
////            preset.pageTitle = self.listArray[indexPath.row];
////            preset.category = @"Person";
////        }
//        NSIndexPath *indexPath = [self.presetTableView indexPathForSelectedRow];
//        
//        NSPredicate *locationPredicate = [NSPredicate predicateWithFormat:@"location CONTAINS[cd] %@", self.listArray[indexPath.row]];
//        
//        
////        PresetSearchResultsTableViewController *preset = segue.destinationViewController;
//        NSArray *array = [[CoreDataHelper fetchUserConnections] filteredArrayUsingPredicate:locationPredicate];;
//        
//        NSLog(@"Segment Controller #3: %lu", (long)array.count);
//
//    }
    
}


@end
