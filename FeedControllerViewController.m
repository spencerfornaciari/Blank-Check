//
//  FeedControllerViewController.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 6/11/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "FeedControllerViewController.h"
#import "NetworkController.h"
#import "BlankCheckViewCell.h"
#import "Gamer.h"

@interface FeedControllerViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *blankCheckCollectionView;

@property (nonatomic) Gamer *one, *two, *three;
@property (nonatomic) NSMutableArray *feedArray;

@property (nonatomic) NetworkController *networkController;

@end

@implementation FeedControllerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Blank Check Labs";
    
    self.networkController = [(AppDelegate *)[[UIApplication sharedApplication] delegate] networkController];
    
    self.one = [Gamer new];
    [self.networkController loadCurrentUserData:self.one];
    
    [self.networkController sendInvitationToUserID:self.one.gamerID];
    NSArray *array = [self.networkController commonConnectionsWithUser:@"mXtsRDLoyK"];
    NSLog(@"%@", array);
    NSLog(@"Count: %lu", (unsigned long)array.count);
    
    self.feedArray = [NSMutableArray new];
    
    [self.feedArray addObject:self.one];
    
    
    self.blankCheckCollectionView.delegate = self;
    self.blankCheckCollectionView.dataSource = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.feedArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BlankCheckViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    Gamer *gamer = self.feedArray[indexPath.row];
    
    [cell setCell:gamer];
    
    return cell;
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
//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"Selected index");
//}

@end
