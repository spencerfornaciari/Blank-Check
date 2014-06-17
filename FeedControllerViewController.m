//
//  FeedControllerViewController.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 6/11/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <Social/Social.h>
#import "FeedControllerViewController.h"
#import "SocialController.h"
#import "NetworkController.h"
#import "BlankCheckViewCell.h"
#import "Gamer.h"

@interface FeedControllerViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *blankCheckCollectionView;

@property (nonatomic) Gamer *one, *two, *three;
@property (nonatomic) NSMutableArray *feedArray;

@property (nonatomic) NetworkController *networkController;
@property (nonatomic) SocialController *socialController;

@end

@implementation FeedControllerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Blank Check Labs";
    
    self.networkController = [(AppDelegate *)[[UIApplication sharedApplication] delegate] networkController];
    
    self.one = [Gamer new];
    [self.networkController loadCurrentUserData:self.one];
    
    
    
    
//    [self.networkController sendInvitationToUserID:self.one.gamerID];
//    NSArray *array = [self.networkController commonConnectionsWithUser:@"mXtsRDLoyK"];
//    NSLog(@"%@", array);
//    NSLog(@"Count: %lu", (unsigned long)array.count);
    
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
    cell.socialButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [cell.socialButton setFrame:CGRectMake(260, 100, 20, 20)];
    [cell addSubview:cell.socialButton];
    [cell.socialButton setBackgroundImage:[UIImage imageNamed:@"Social-Share"] forState:UIControlStateNormal];
    [cell.socialButton addTarget:self action:@selector(buttonPress) forControlEvents:UIControlEventTouchDown];
    
    return cell;
}

//-(void)buttonPress {
//    NSLog(@"Button Press");
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Share this profile"
//                                                             delegate:self
//                                                    cancelButtonTitle:@"Cancel"
//                                               destructiveButtonTitle:nil otherButtonTitles:@"LinkedIn", @"Twitter", @"Facebook", nil];
//    
//    [actionSheet showInView:self];
//}

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

#pragma mark - Social Button

-(void)buttonPress {
    NSLog(@"Button Press");
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Share this profile"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil otherButtonTitles:@"LinkedIn", @"Twitter", @"Facebook", nil];
    
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    switch (buttonIndex) {
        case 0:
        {
            NSLog(@"LinkedIn");
            [SocialController shareOnLinkedin:self.one];;
            //            [socialController shareOnFacebook:<#(Gamer *)#>]
            
        }    //            SLComposeViewController *viewController = [SocialController shareOnFacebook:gamer];
        break;
            
        case 1:
        {
            NSLog(@"Twitter");
            SLComposeViewController *twitterViewController = [SocialController shareOnTwitter:self.one];
            
            if (twitterViewController) {
                [self presentViewController:twitterViewController animated:YES completion:nil];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Twitter Account Available" message:@"Please enable Twitter to do this" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
        break;
            
        case 2:
        {
            NSLog(@"Facebook");
            SLComposeViewController *facebookViewController = [SocialController shareOnFacebook:self.one];
            //
            if (facebookViewController) {
                [self presentViewController:facebookViewController animated:YES completion:nil];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Facebook Account Available" message:@"Please enable Facebook to do this" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
        break;
    }
}

@end
