//
//  FeedTableViewCell.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 6/18/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "FeedTableViewCell.h"

@implementation FeedTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

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
    NSLog(@"Score: %@", [gamer.valueArray firstObject]);
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:gamer.imageLocalLocation];
    
    if (!fileExists) {
        [self downloadProfileImage:gamer];
    } else {
        gamer.profileImage = [UIImage imageWithData:[NSData dataWithContentsOfMappedFile:gamer.imageLocalLocation]];
        self.profileImage.image = gamer.profileImage;
    }
    
    self.profileImage.contentMode = UIViewContentModeScaleAspectFit;
    self.profileImage.layer.cornerRadius = 35.f;
    self.profileImage.layer.masksToBounds = TRUE;
}

-(void)downloadProfileImage:(Gamer *)gamer {
    
    NSURL *url = gamer.imageURL;
    NSLog(@"URL: %@", url);
    
    NSOperationQueue *operationQueue = [(AppDelegate *)[[UIApplication sharedApplication] delegate] blankQueue];
    [operationQueue addOperationWithBlock:^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        gamer.profileImage = image;
        
        NSString *fullName = [NSString stringWithFormat:@"%@%@", gamer.firstName, gamer.lastName];
        gamer.imageLocalLocation = [NSString stringWithFormat:@"%@/%@.jpg", [self documentsDirectoryPath], fullName];
        [data writeToFile:gamer.imageLocalLocation atomically:YES];
        
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:gamer.imageLocalLocation];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (!fileExists) {
                self.profileImage.image = [UIImage imageNamed:@"default-user"];
            } else {
                self.profileImage.image = gamer.profileImage;
            }
        }];
    }];
        
//        NSString *str=[here Your image link for download];
//        
//        UIImage *img = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:str]]];
//        
//        [dicImages_msg setObject:img forKey:[[msg_array objectAtIndex:path.row] valueForKey:@"image name or image link same as cell for row"]];
//        
//        [tableview performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];

}

#pragma mark - Directories path

- (NSString *)documentsDirectoryPath
{
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    return [documentsURL path];
}

@end
