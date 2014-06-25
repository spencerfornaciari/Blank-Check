//
//  SearchViewController.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 6/3/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "SearchViewController.h"
#import "PresetViewController.h"
#import "Gamer.h"
#import "Position.h"
#import "UIColor+BlankCheckColors.h"

@interface SearchViewController ()
@property (strong, nonatomic) IBOutlet UISegmentedControl *searchSegmentController;
@property (strong, nonatomic) IBOutlet UITableView *presetTableView;
@property (nonatomic) NSArray *peopleArray, *titleArray, *locationArray, *listArray;

- (IBAction)changeSegment:(id)sender;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Search";
    self.presetTableView.dataSource = self;
    self.presetTableView.delegate = self;
    self.searchBar.delegate = self;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    NSLog(@"Search: %@", self.string);
    
    self.searchBar.barTintColor = [UIColor blankCheckBlue];
    
    self.searchSegmentController.selectedSegmentIndex = 0;
    
    self.peopleArray = [NSArray arrayWithObjects:@"Steve Ballmer", @"Mark Zuckerberg", @"Tom Brady", @"Martha Steward", @"Brad Pitt", @"Oprah Winfrey", @"Beyonce Knowles", @"Lebron James", @"Kobe Bryant", @"Someone Else", nil];
    
    self.titleArray = [NSArray arrayWithObjects:@"marketing manager", @"marketing director", @"marketing specialist", @"associate marketing manager", @"marketing intern", nil];
    
    self.locationArray = [NSArray arrayWithObjects:@"Seattle", @"Los Angeles", @"New York", @"Chicago", @"Phoenix", @"Las Vegas", @"San Francisco", @"Austin", @"Washington DC", @"Boston", nil];
//    self.navigationController.navigationBar.topItem.backBarButtonItem.title = @"Home";
    
    self.listArray = self.peopleArray;
    
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]
                                initWithTitle:@"Home"
                                style:UIBarButtonItemStyleBordered
                                target:self
                                action:nil];
    self.navigationController.navigationBar.topItem.backBarButtonItem=btnBack;
    

    UILabel *presetSearches = [[UILabel alloc] initWithFrame:CGRectMake(0, 130, self.view.frame.size.width, 40)];
    presetSearches.textAlignment = NSTextAlignmentCenter;
    presetSearches.font = [UIFont fontWithName:@"Avenir" size:19.0];
    presetSearches.text = @"Or choose a popular search...";
    [self.view addSubview:presetSearches];

    
    
    // Do any additional setup after loading the view.
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

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"Text: %@", searchText);

    //Full Name Predicate
    NSPredicate *fullNamePredicate = [NSPredicate predicateWithFormat:@"fullName CONTAINS[cd] %@", searchText];
    NSArray *predicateArray = [NSArray arrayWithArray:[self.searchArray filteredArrayUsingPredicate:fullNamePredicate]];
    
    //Location Predicate
//    NSPredicate *locationPredicate = [NSPredicate predicateWithFormat:@"location CONTAINS[cd] %@", searchText];
//    NSArray *predicateArray = [NSArray arrayWithArray:[self.searchArray filteredArrayUsingPredicate:locationPredicate]];
    
    //Industry Predicate
//    NSPredicate *industryPredicate = [NSPredicate predicateWithFormat:@"industry CONTAINS[cd] %@", searchText];
//    NSArray *predicateArray = [NSArray arrayWithArray:[self.searchArray filteredArrayUsingPredicate:industryPredicate]];
    
    //Headline Predicate
//    NSPredicate *headlinePredicate = [NSPredicate predicateWithFormat:@"headline CONTAINS[cd] %@", searchText];
//    NSArray *predicateArray = [NSArray arrayWithArray:[self.searchArray filteredArrayUsingPredicate:headlinePredicate]];
    
    //Job Title Predicate
//    NSPredicate *jobTitlePredicate = [NSPredicate predicateWithFormat:@"ANY SELF.currentPositionArray.title CONTAINS[cd] %@", searchText];
//    NSArray *predicateArray = [NSArray arrayWithArray:[self.searchArray filteredArrayUsingPredicate:jobTitlePredicate]];
    
    for (Gamer *gamer in predicateArray) {
        NSLog(@"%@", gamer.fullName);
    }
    
    NSLog(@"Name Count: %lu", (unsigned long)predicateArray.count);
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"Search Button Clicked");
    NSLog(@"Search Bar Text: %@", searchBar.text);
    
    [searchBar resignFirstResponder];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    if (self.searchSegmentController.selectedSegmentIndex == 0) {
        NSIndexPath *indexPath = [self.presetTableView indexPathForSelectedRow];
        
        PresetViewController *preset = segue.destinationViewController;
        preset.pageTitle = self.listArray[indexPath.row];
        preset.category = @"Person";
    } else if (self.searchSegmentController.selectedSegmentIndex == 1) {
        NSLog(@"Segment Controller #2");
    } else {
        NSLog(@"Segment Controller #3");

    }
    
    
    
}


@end
