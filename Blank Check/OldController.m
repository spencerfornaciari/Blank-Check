//
//  OldController.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 8/23/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "OldController.h"

@implementation OldController

#pragma mark - Textalytics

+(NSArray *)checkProfileText:(NSString *)string {
    
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    NSString *searchString = [NSString stringWithFormat:@"tt=ecr&dic=chetsdpCA&key=1c03ecaeb9c146a07056c4049064cb3a&of=json&lang=en&txt=%@&txtf=plain&url=&_tte=e&_ttc=c&_ttr=r&dm=4&cont=&ud=spencer%%40impactinterview.com-en-got", [string uppercaseString]];
    
    NSData *data = [searchString dataUsingEncoding:NSUTF8StringEncoding];
    //
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://textalytics.com/core/topics-1.2"]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    //
    //    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    //    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    ////
    //    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
    //                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    //            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    //
    ////                                                    NSDictionary *entityDictionary = [dictionary valueForKeyPath:@"entity_list.variant_list.form"];
    ////                                                    NSLog(@"%@", entityDictionary);
    ////                                                    NSString *entityString = [dictionary valueForKeyPath:@"entity_list.variant_list.form"];
    ////                                                    NSLog(@"String: %@", entityString);
    //
    ////
    //            NSArray *entityArray = [dictionary objectForKey:@"entity_list"];
    //
    //            NSString *entityString;
    //            if (entityArray.count > 0) {
    //                NSDictionary *entityDictionary = entityArray[0];
    //                NSArray *variantArray = [entityDictionary valueForKey:@"variant_list"];
    //                NSDictionary *variantDictionary = variantArray[0];
    //
    //                entityString = [variantDictionary valueForKeyPath:@"form"];
    //                NSLog(@"Array: %@", [NetworkController jobValue:entityString]);
    //            } else {
    //                NSLog(@"Array: %@", [NetworkController jobValue:@"OTHER"]);
    //            }
    //
    ////
    ////            NSString *entityString;
    ////            if (entityArray) {
    ////                NSDictionary *entityDictionary = ;
    ////                entityString = [entityDictionary valueForKeyPath:@"variant_list.form"];
    ////                NSLog(@"%@", entityString);
    ////            }
    //
    //    }];
    //
    //    [dataTask resume];
    
    NSURLResponse *response;
    NSError *error;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
    
    //                                                    NSDictionary *entityDictionary = [dictionary valueForKeyPath:@"entity_list.variant_list.form"];
    //                                                    NSLog(@"%@", entityDictionary);
    //                                                    NSString *entityString = [dictionary valueForKeyPath:@"entity_list.variant_list.form"];
    //                                                    NSLog(@"String: %@", entityString);
    
    //
    NSArray *entityArray = [dictionary objectForKey:@"entity_list"];
    return entityArray;
    
    //    NSString *entityString;
    //    if (entityArray.count > 0) {
    //        NSDictionary *entityDictionary = entityArray[0];
    //        NSArray *variantArray = [entityDictionary valueForKey:@"variant_list"];
    //        NSDictionary *variantDictionary = variantArray[0];
    //
    //        entityString = [variantDictionary valueForKeyPath:@"form"];
    //        NSLog(@"Array: %@", [NetworkController jobValue:entityString]);
    //        return [NetworkController jobValue:entityString];
    //    } else {
    //        NSLog(@"Array: %@", [NetworkController jobValue:@"OTHER"]);
    //        return [NetworkController jobValue:@"OTHER"];
    //    }
    
    
    //
    //    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
    //
    //    NSArray *entityArray = [dictionary objectForKey:@"entity_list"];
    //
    //    NSString *entityString;
    //    if (entityArray) {
    //        NSDictionary *entityDictionary = entityArray[0];
    //        entityString = [entityDictionary valueForKeyPath:@"variant_list.form"];
    //        NSLog(@"%@", entityString);
    //    }
    
    
    
    /*    NSURL *url = [NSURL URLWithString:LINKEDIN_TOKEN_URL];
     NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
     [request setHTTPMethod:@"POST"];
     [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
     [request setHTTPBody:[token dataUsingEncoding:NSUTF8StringEncoding]];
     [request setValue:@"json" forHTTPHeaderField:@"x-li-format"]; // per Linkedin API: https://developer.linkedin.com/documents/api-requests-json*/
    
    //    NSLog(@"Entity Value: %@", [jobDictionary objectForKey:entityString]);
    
    /*
     */
    
}



-(void)listDictionaries {
    NSURLSessionConfiguration *defaultSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultSessionConfiguration];
    
    __block NSArray *customDictionaries;
    __block NSDictionary *customDictionary;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://textalytics.com/api/sempub/1.0/manage/dictionary_list/?key=b8d169500ad3ded96d69054182f829cd"]];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        customDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSArray *array = [customDictionary valueForKey:@"dictionary_list"];
        NSLog(@"Dictionary Count: %@", [array[0] valueForKey:@"description"]);
        customDictionaries = array;
        
    }];
    
    
    [dataTask resume];
    
}

-(void)readDictionaryWithName:(NSString *)name {
    NSURLSessionConfiguration *defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultConfiguration];
    
    NSString *urlString = [NSString stringWithFormat:@"https://textalytics.com/api/sempub/1.0/manage/dictionary_list/%@/?key=b8d169500ad3ded96d69054182f829cd", name];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSString *stringResponse = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        
        NSLog(@"Read: %@", stringResponse);
        
    }];
    
    [dataTask resume];
}


@end
