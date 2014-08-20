//
//  FeedTableViewCell.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 6/18/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "FeedTableViewCell.h"
#import "ValueController.h"

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

-(void)setCell:(Connection *)connection {
    self.connection = connection;
    //Set Name
    self.userNameLabel.text = [NSString stringWithFormat:@"%@ %@", connection.firstName, connection.lastName];
    
    //Set Value
    NSArray *jobArray = [self.connection.jobs allObjects];
//    Job *job = jobArray[0];
//    NSArray *array = [NetworkController checkProfileText:job.title];
    
    //Generating Values
//    NSArray *array = [ValueController jobValue:[ValueController careerSearch:self.connection]];
//    NSLog(@"Value: $%ld", (long)[array[0] integerValue]);
//    
//    NSNumberFormatter *formatter = [NSNumberFormatter new];
//    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
//    NSString *valueString = [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:array[0]]];
    //End Generating values
    
    if (connection.values.count == 0) {
        self.scoreLabel.text = @"Click to see the value!";
    } else {
        Value *currentValue = [connection.values lastObject];
        
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        self.scoreLabel.text = [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:currentValue.marketPrice]];
    }
    
    
    NSURL *url = [NSURL URLWithString:connection.smallImageURL];
    //Set Profile Image
    if (url) {
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:connection.smallImageLocation];
        BOOL fileExists2 = [[NSFileManager defaultManager] fileExistsAtPath:connection.imageLocation];
        
        if (!fileExists) {
            [self downloadProfileImage:connection];
        } else {
            if (fileExists2) {
                self.profileImage.image = [UIImage imageWithData:[NSData dataWithContentsOfMappedFile:connection.imageLocation]];
            } else {
                self.profileImage.image = [UIImage imageWithData:[NSData dataWithContentsOfMappedFile:connection.smallImageLocation]];
            }
        }
    } else {
        self.profileImage.image = [UIImage imageNamed:@"default-user"];
    }
    
    self.profileImage.contentMode = UIViewContentModeScaleAspectFit;
    self.profileImage.layer.cornerRadius = 35.f;
    self.profileImage.layer.masksToBounds = TRUE;
}


-(void)downloadProfileImage:(Connection *)connection {
    
    //Grab Image URL
    NSURL *url = [NSURL URLWithString:connection.smallImageURL];
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:[NSURLRequest requestWithURL:url]];
    
    [downloadTask resume];
    
//    NSOperationQueue *operationQueue = [(AppDelegate *)[[UIApplication sharedApplication] delegate] blankQueue];
//    [operationQueue addOperationWithBlock:^{
//        
//        NSData *data = [NSData dataWithContentsOfURL:url];
//        UIImage *image = [UIImage imageWithData:data];
//        
//        [data writeToFile:connection.smallImageLocation atomically:YES];
//        
//        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:connection.smallImageLocation];
//        
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            if (!fileExists) {
//                self.profileImage.image = [UIImage imageNamed:@"default-user"];
//            } else {
//                self.profileImage.image = image;
//            }
//        }];
//    }];
    
}


#pragma mark - Directories path

- (NSString *)documentsDirectoryPath
{
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    return [documentsURL path];
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    
    NSData *data = [NSData dataWithContentsOfURL:location];
    UIImage *image = [UIImage imageWithData:data];
    
    [data writeToFile:self.connection.smallImageLocation atomically:YES];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.profileImage.image = image;
    }];
    
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
    
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
}

@end
