//
//  SocialHelper.m
//
//  Created by Spencer Fornaciari on 8/12/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import "SocialHelper.h"

@implementation SocialHelper

+(ACAccountStore *)accessAccountStore {
    ACAccountStore *accounts = [(AppDelegate *)[[UIApplication sharedApplication] delegate] accounts];

    return accounts;
}

+(BOOL)checkTwitterAccount {
    ACAccountType *twitterType = [[SocialHelper accessAccountStore] accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    NSArray *twitterAccounts = [[SocialHelper accessAccountStore] accountsWithAccountType:twitterType];
    
    if (twitterAccounts.count > 0) {
        return TRUE;
    } else {
        return FALSE;
    }
}

+(ACAccount *)twitterAccount {
    ACAccountType *twitterType = [[SocialHelper accessAccountStore] accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    NSArray *twitterAccounts = [[SocialHelper accessAccountStore] accountsWithAccountType:twitterType];
    
    return [twitterAccounts lastObject];
}

+(ACAccount *)accessTwitterAccount {
    ACAccountType *twitterType = [[SocialHelper accessAccountStore] accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    __block ACAccount *twitterAccount;

    [[SocialHelper accessAccountStore] requestAccessToAccountsWithType:twitterType options:nil completion:^(BOOL granted, NSError *error) {
        if (granted == 0) {
            NSLog(@"%@", error.localizedDescription);
        }
        
        if (granted) {
            NSArray *accounts = [[SocialHelper accessAccountStore] accountsWithAccountType:twitterType];
            [[SocialHelper accessAccountStore] saveAccount:[accounts lastObject] withCompletionHandler:^(BOOL success, NSError *error) {
                if (success) {
                    NSLog(@"Success");
                    twitterAccount = [accounts lastObject];
                } else {
                    NSLog(@"Failure");
                }
            }];
        }
    }];
    
    return twitterAccount;
}

+(void)sendTwitterPost:(id)sender {
    Worker *worker;
    Connection *connection;
    
    BOOL isWorker = false;
    
    if ([sender isKindOfClass:[Worker class]]) {
        worker = (Worker *)sender;
        isWorker = TRUE;
        
    }
    
    if ([sender isKindOfClass:[Connection class]]) {
        connection = (Connection *)sender;
    }
    
    
    ACAccountType *twitterType = [[SocialHelper accessAccountStore] accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    ACAccount *twitterAccount = [SocialHelper twitterAccount];
    
    SLRequestHandler requestHandler =
    ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (responseData) {
            NSInteger statusCode = urlResponse.statusCode;
            if (statusCode >= 200 && statusCode < 300) {
                NSDictionary *postResponseData =
                [NSJSONSerialization JSONObjectWithData:responseData
                                                options:NSJSONReadingMutableContainers
                                                  error:NULL];
                NSLog(@"[SUCCESS!] Created Tweet with ID: %@", postResponseData[@"id_str"]);
            }
            else {
                NSLog(@"[ERROR] Server responded: status code %ld %@", (long)statusCode,
                      [NSHTTPURLResponse localizedStringForStatusCode:statusCode]);
            }
        }
        else {
            NSLog(@"[ERROR] An error occurred while posting: %@", [error localizedDescription]);
        }
    };
    
    ACAccountStoreRequestAccessCompletionHandler accountStoreHandler =
    ^(BOOL granted, NSError *error) {
        if (granted) {
            NSURL *url = [NSURL URLWithString:@"https://api.twitter.com"
                          @"/1.1/statuses/update_with_media.json"];
            
            NSDictionary *params;
            NSData *imageData;
            if (isWorker) {
                params = @{@"status" : @"Check out my value!"};
                imageData = UIImageJPEGRepresentation([UIImage imageWithContentsOfFile:worker.imageLocation], 1.f);
            } else {
                params = @{@"status" : @"Check out my friend's value"};
                imageData = UIImageJPEGRepresentation([UIImage imageWithContentsOfFile:connection.imageLocation], 1.f);
            }
            
            SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                    requestMethod:SLRequestMethodPOST
                                                              URL:url
                                                       parameters:params];
            
            [request addMultipartData:imageData
                             withName:@"media[]"
                                 type:@"image/jpeg"
                             filename:@"image.jpg"];
            [request setAccount:twitterAccount];
            [request performRequestWithHandler:requestHandler];
        }
        else {
            NSLog(@"[ERROR] An error occurred while asking for user authorization: %@",
                  [error localizedDescription]);
        }
    };
    
    [[SocialHelper accessAccountStore] requestAccessToAccountsWithType:twitterType
                                       options:NULL
                                    completion:accountStoreHandler];
}

+(BOOL)checkFacebookAccount {
    ACAccountType *facebookType = [[SocialHelper accessAccountStore] accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    NSArray *facebookAccounts = [[SocialHelper accessAccountStore] accountsWithAccountType:facebookType];
    
    if (facebookAccounts.count > 0) {
        return TRUE;
    } else {
        return FALSE;
    }
}

+(ACAccount *)facebookAccount {
    ACAccountType *facebookType = [[SocialHelper accessAccountStore] accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    NSArray *facebookAccounts = [[SocialHelper accessAccountStore] accountsWithAccountType:facebookType];
    
    return [facebookAccounts lastObject];
}

+(ACAccount *)accessFacebookAccount {
    ACAccountType *facebookType = [[SocialHelper accessAccountStore] accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    __block ACAccount *facebookAccount;
    
    NSDictionary *options = @{
                              ACFacebookAppIdKey : @"702582039796891",
                              ACFacebookPermissionsKey : @[@"email", @"publish_actions"],
                              ACFacebookAudienceKey: ACFacebookAudienceFriends
                              };
    
    [[SocialHelper accessAccountStore] requestAccessToAccountsWithType:facebookType options:options completion:^(BOOL granted, NSError *error) {
        NSLog(@"%i", granted);
        if (granted == 0) {
            NSLog(@"%@", error.localizedDescription);
        }

        if (granted) {
            NSArray *accounts = [[SocialHelper accessAccountStore] accountsWithAccountType:facebookType];
            [[SocialHelper accessAccountStore] saveAccount:[accounts lastObject] withCompletionHandler:^(BOOL success, NSError *error) {
                if (success) {
                    NSLog(@"Success");
                } else {
                   NSLog(@"Failure");
                }
            }];
        }
    }];
    
    return facebookAccount;
}

+(void)sendFacebookPost:(id)sender {
    Worker *worker;
    Connection *connection;
    
    BOOL isWorker = false;
    
    if ([sender isKindOfClass:[Worker class]]) {
        worker = (Worker *)sender;
        isWorker = TRUE;
        
    }
    
    if ([sender isKindOfClass:[Connection class]]) {
        connection = (Connection *)sender;
    }
    
    ACAccount *facebookAccount = [SocialHelper facebookAccount];
    
    NSDictionary *parameters = @{@"message" : @"test", @"link": @"http://www.BlankCheckLabs.com"};
    NSURL *URL = [NSURL URLWithString:@"https://graph.facebook.com/me/photos"];
    
    
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                            requestMethod:SLRequestMethodPOST
                                                      URL:URL
                                               parameters:parameters];
    
    NSData *imageData;
    if (isWorker) {
        imageData = UIImageJPEGRepresentation([UIImage imageWithContentsOfFile:worker.imageLocation], 1.f);
    } else {
        imageData = UIImageJPEGRepresentation([UIImage imageWithContentsOfFile:connection.imageLocation], 1.f);
    }
    
    [request addMultipartData: imageData
                     withName:@"source"
                         type:@"multipart/form-data"
                     filename:@"TestImage"];
    
    [request setAccount:facebookAccount];
    
    // Perform request
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData
                                                                           options:kNilOptions
                                                                             error:&error];
        NSLog(@"%@", responseDictionary);
        // Check for errors in the responseDictionary
    }];
}

+(void)shareOnLinkedin:(id)sender {
    Worker *worker;
    Connection *connection;
    
    BOOL isWorker = false;
    
    if ([sender isKindOfClass:[Worker class]]) {
        worker = (Worker *)sender;
        isWorker = TRUE;
    }
    
    if ([sender isKindOfClass:[Connection class]]) {
        connection = (Connection *)sender;
    }
    
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    NSString *urlString = [NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~/shares?oauth2_access_token=%@", accessToken];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    
    NSDictionary *contentDictionary;
    if (isWorker) {
        contentDictionary = @{@"title":@"Utilize Blank Check Labs to see my value...and YOURS!",
                                            @"description":@"New app utilizing Linkedin's API to determine job value",
                                            @"submitted-url":@"http://www.BlankCheckLabs.com",
                                            @"submitted-image-url":worker.imageURL
                                            };
    } else {
        contentDictionary = @{@"title":@"Utilize Blank Check Labs to find your value!",
                                            @"description":@"New app utilizing Linkedin's API to determine job value",
                                            @"submitted-url":@"http://www.BlankCheckLabs.com",
                                            @"submitted-image-url":connection.imageURL
                                            };
    }
    
    NSDictionary *visibilityDictionary = @{@"code":@"anyone"};
    
    NSDictionary *shareDictionary;
    
    if (isWorker) {
        shareDictionary = @{@"comment":@"Check out my value!",
                                          @"content":contentDictionary,
                                          @"visibility":visibilityDictionary};
    } else {
        shareDictionary = @{@"comment":@"Check out your value!",
                                          @"content":contentDictionary,
                                          @"visibility":visibilityDictionary};
    }
    
    NSError *jsonError;
    
    NSData *shareData = [NSJSONSerialization dataWithJSONObject:shareDictionary options:NSJSONWritingPrettyPrinted error:&jsonError];
    
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"json" forHTTPHeaderField:@"x-li-format"];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:shareData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *stringResponse = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        
        NSLog(@"%@", stringResponse);
        
    }];
    
    [uploadTask resume];

}

+(void)sendInvitationToUserID:(id)sender
{
    Worker *worker;
    Connection *connection;
    
    BOOL isWorker = false;
    
    if ([sender isKindOfClass:[Worker class]]) {
        worker = (Worker *)sender;
        isWorker = TRUE;
    }
    
    if ([sender isKindOfClass:[Connection class]]) {
        connection = (Connection *)sender;
    }
    
    NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    NSString *url = [NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~/mailbox?oauth2_access_token=%@", string];
    
    NSDictionary *recipientPathDictionary;
    if (isWorker) {
        recipientPathDictionary = @{@"_path":[NSString stringWithFormat:@"/people/%@", worker.idNumber]};

    } else {
        recipientPathDictionary = @{@"_path":[NSString stringWithFormat:@"/people/%@", connection.idNumber]};
    }
    
    NSDictionary *recipientDictionary = @{@"person": recipientPathDictionary};
    
    NSArray *array = [NSArray arrayWithObjects:recipientDictionary, nil];
    
    NSDictionary *recipients = @{@"values":array};
    
    NSURL *linkURL = [NSURL URLWithString:@"http://comingsoon.blankchecklabs.com/"];
    
    NSString *body = [NSString stringWithFormat:@"Join me on the app Blank Check Labs. \n%@", linkURL];
    
    NSDictionary *messageDictionary = @{@"subject":@"Invitation to join Blank Check Labs",
                                        @"body":body,
                                        @"recipients":recipients};
    
    NSError *JSONError;
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:messageDictionary options:NSJSONWritingPrettyPrinted error:&JSONError];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"json" forHTTPHeaderField:@"x-li-format"];
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:postData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *stringResponse = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        
        NSLog(@"%@", stringResponse);
    }];
    
    [uploadTask resume];
}



@end
