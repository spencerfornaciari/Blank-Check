//
//  FeedTableViewCell.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 6/18/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "FeedTableViewCell.h"

@implementation FeedTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCell:(Gamer *)gamer {
    self.userNameLabel.text = gamer.fullName;
    self.scoreLabel.text = [NSString stringWithFormat:@"$%@", [gamer.valueArray lastObject]];
    
    NSURL *url = gamer.smallImageURL;
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    gamer.smallProfileImage = image;
    
//    NSString *fullName = [NSString stringWithFormat:@"%@%@", gamer.firstName, gamer.lastName];
//    gamer.smallImageLocalLocation = [NSString stringWithFormat:@"%@/%@_small.jpg", [self documentsDirectoryPath], fullName];
//    [data writeToFile:gamer.smallImageLocalLocation atomically:YES];
//    self.profileImage.image = gamer.smallProfileImage;
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:gamer.smallImageLocalLocation];
    
    if (!fileExists) {
        [self downloadProfileImage:gamer];
    } else {
        gamer.smallProfileImage = [UIImage imageWithData:[NSData dataWithContentsOfMappedFile:gamer.smallImageLocalLocation]];
        self.profileImage.image = gamer.smallProfileImage;
    }
    
    self.profileImage.contentMode = UIViewContentModeScaleAspectFit;
    self.profileImage.layer.cornerRadius = 35.f;
    self.profileImage.layer.masksToBounds = TRUE;
}

-(void)downloadProfileImage:(Gamer *)gamer {
    
    
    //Loggin image URL
    NSURL *url = gamer.smallImageURL;
    
    NSOperationQueue *operationQueue = [(AppDelegate *)[[UIApplication sharedApplication] delegate] blankQueue];
    [operationQueue addOperationWithBlock:^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        gamer.smallProfileImage = image;
        
        NSString *fullName = [NSString stringWithFormat:@"%@%@", gamer.firstName, gamer.lastName];
        gamer.smallImageLocalLocation = [NSString stringWithFormat:@"%@/%@_small.jpg", [self documentsDirectoryPath], fullName];
        [data writeToFile:gamer.smallImageLocalLocation atomically:YES];
        
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:gamer.smallImageLocalLocation];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (!fileExists) {
                self.profileImage.image = [UIImage imageNamed:@"default-user"];
            } else {
                self.profileImage.image = gamer.smallProfileImage;
            }
        }];
    }];

}

#pragma mark - Directories path

- (NSString *)documentsDirectoryPath
{
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    return [documentsURL path];
}

@end
