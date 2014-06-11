//
//  FeedControllerViewController.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 6/11/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "FeedControllerViewController.h"
#import "BlankCheckViewCell.h"
#import "Gamer.h"

@interface FeedControllerViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *blankCheckCollectionView;

@property (nonatomic) Gamer *one, *two, *three;
@property (nonatomic) NSMutableArray *feedArray;

@end

@implementation FeedControllerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Blank Check Labs";
    
    self.feedArray = [NSMutableArray new];
    
    self.one = [Gamer new];
    self.one.fullName = @"Spencer Fornaciari";
    [self.feedArray addObject:self.one];
    
    self.two = [Gamer new];
    self.two.fullName = @"Lewis Lin";
    [self.feedArray addObject:self.two];
    
    self.three = [Gamer new];
    self.three.fullName = @"Bill Gates";
    [self.feedArray addObject:self.three];
    
    
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
