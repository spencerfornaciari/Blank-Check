//
//  SearchViewController.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 6/3/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "PresetSearchViewController.h"
#import "PresetViewController.h"
#import "UIColor+BlankCheckColors.h"

@interface PresetSearchViewController ()
@property (strong, nonatomic) IBOutlet UISegmentedControl *searchSegmentController;
@property (strong, nonatomic) IBOutlet UITableView *presetTableView;
@property (nonatomic) NSArray *peopleArray, *titleArray, *locationArray, *listArray, *predicateArray;

- (IBAction)changeSegment:(id)sender;

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
    
    self.titleArray = [NSArray arrayWithObjects:@"marketing manager", @"marketing director", @"marketing specialist", @"associate marketing manager", @"marketing intern", nil];
    
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if (self.searchSegmentController.selectedSegmentIndex == 0) {
        if ([segue.identifier isEqualToString:@"presetView"]) {
            NSIndexPath *indexPath = [self.presetTableView indexPathForSelectedRow];
            PresetViewController *preset = segue.destinationViewController;
            preset.pageTitle = self.listArray[indexPath.row];
            preset.category = @"Person";
        }
    } else if (self.searchSegmentController.selectedSegmentIndex == 1) {
        NSLog(@"Segment Controller #2");
        NSIndexPath *indexPath = [self.presetTableView indexPathForSelectedRow];
        [NetworkController checkProfileText:self.titleArray[indexPath.row]];
    } else {
        NSLog(@"Segment Controller #3");

    }
    
}


@end
