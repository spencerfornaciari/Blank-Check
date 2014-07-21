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

-(void)setCoreCell:(Connection *)connection {
    self.userNameLabel.text = [NSString stringWithFormat:@"%@ %@", connection.firstName, connection.lastName];
    self.scoreLabel.text = @"1,000,000";
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
    BOOL fileExists2 = [[NSFileManager defaultManager] fileExistsAtPath:gamer.imageLocalLocation];

    if (!fileExists) {
        [self downloadProfileImage:gamer];
    } else {
        if (fileExists2) {
            gamer.profileImage = [UIImage imageWithData:[NSData dataWithContentsOfMappedFile:gamer.imageLocalLocation]];
            self.profileImage.image = gamer.profileImage;
        } else {
            gamer.smallProfileImage = [UIImage imageWithData:[NSData dataWithContentsOfMappedFile:gamer.smallImageLocalLocation]];
            self.profileImage.image = gamer.smallProfileImage;
        }
    }
    
    self.profileImage.contentMode = UIViewContentModeScaleAspectFit;
    self.profileImage.layer.cornerRadius = 35.f;
    self.profileImage.layer.masksToBounds = TRUE;
}

-(void)downloadProfileImage:(Gamer *)gamer {
//    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//    NSManagedObjectContext *context = appDelegate.managedObjectContext;
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Worker" inManagedObjectContext:context];
//    NSManagedObject *cellObject = nil;
    
//    NSFetchRequest *request = [NSFetchRequest new];
//    [request setEntity:entity];
//    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstName = %@", gamer.firstName];
//    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"lastName = %@", gamer.lastName];
//    NSPredicate *final = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicate, predicate2]];
//    [request setPredicate:final];
//    
//    NSError *error;
//    NSArray *objects = [context executeFetchRequest:request error:&error];
//    cellObject = objects[0];
    
    //Loggin image URL
    NSURL *url = gamer.smallImageURL;
    
    NSOperationQueue *operationQueue = [(AppDelegate *)[[UIApplication sharedApplication] delegate] blankQueue];
    [operationQueue addOperationWithBlock:^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        gamer.smallProfileImage = image;
        
        NSString *fullName = [NSString stringWithFormat:@"%@%@", gamer.firstName, gamer.lastName];
        gamer.smallImageLocalLocation = [NSString stringWithFormat:@"%@/%@_small.jpg", [self documentsDirectoryPath], fullName];
        
//        [cellObject setValue:gamer.smallImageLocalLocation forKey:@"smallImageLocation"];
        
        [data writeToFile:gamer.smallImageLocalLocation atomically:YES];
        
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:gamer.smallImageLocalLocation];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (!fileExists) {
                self.profileImage.image = [UIImage imageNamed:@"default-user"];
            } else {
                self.profileImage.image = gamer.smallProfileImage;
            }
            
//            NSError *error2;
//            [context save:&error2];
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
