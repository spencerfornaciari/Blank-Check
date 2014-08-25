//
//  LocationController.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 8/21/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "LocationController.h"

@implementation LocationController

+(void)getLocationData:(id)sender {
    Connection *connection;
    Worker *worker;
    NSArray *words;
    
    if ([sender isKindOfClass:[Connection class]]) {
        connection = (Connection *)sender;
        words = [connection.location componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    } else {
        worker = (Worker *)sender;
        words = [worker.location componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    }

    NSString *location = @"";
    if (words.count > 1) {
        for (NSString *string in words) {
            if ([string isEqualToString:@"Greater"]) {
                
            } else if ([string isEqualToString:@"Area"] || [string isEqualToString:@"Area,"]) {
                
            } else if ([string isEqualToString:@"Bay"] || [string isEqualToString:@"Bay,"]) {
                
            } else {
                if ([location isEqualToString:@""]) {
                    location = string;
                } else {
                    location = [location stringByAppendingString:[NSString stringWithFormat:@" %@", string]];
                }
            }
        }
    } else {
        location = words[0];
    }
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    
    [geocoder geocodeAddressString:location
                 completionHandler:^(NSArray* placemarks, NSError* error){
                     NSLog(@"Placemarks Count %lu", (unsigned long)placemarks.count);
                     
                     for (CLPlacemark* placemark in placemarks)
                     {
                         // Process the placemark.
                         NSLog(@"Zip Code: %@", placemark.addressDictionary);
                         
                         //                         NSLog(@"Long: %f, Lat: %f", placemark.location.coordinate.longitude, placemark.location.coordinate.latitude);
                         if (placemarks.count > 0) {
                             NSString *city;
                             if (placemark.locality) {
                                 city = placemark.locality;
                             } else {
                                 city = @"";
                             }
                             
                             NSString *county;
                             if (placemark.subAdministrativeArea) {
                                 county = placemark.subAdministrativeArea;
                             } else {
                                 county = @"";
                             }
                             
                             NSString *state;
                             if (placemark.administrativeArea) {
                                 state = placemark.administrativeArea;
                             } else {
                                 state = @"";
                             }
                             
                             NSString *country;
                             if (placemark.country) {
                                 country = placemark.country;
                             } else {
                                 country = @"";
                             }
                             
                             if ([sender isKindOfClass:[Connection class]]) {
                                 connection.city = city;
                                 connection.state = state;
                                 connection.county = county;
                                 connection.country = country;
                                 [CoreDataHelper saveContext];
                                 
                             } else {
                                 worker.city = city;
                                 worker.state = state;
                                 worker.county = county;
                                 worker.country = country;
                                 [CoreDataHelper saveContext];
                             }

                         }
                         
                     }
                 }];
    
}

+(void)getZipCode:(id)sender {
    Connection *connection;
    Worker *worker;
    NSString *country, *city, *state;
    
    if ([sender isKindOfClass:[Connection class]]) {
        connection = (Connection *)sender;
        country = connection.country;
        city = connection.city;
        state = connection.state;
    } else {
        worker = (Worker *)sender;
        country = worker.country;
        city = worker.city;
        state = worker.state;
    }

//    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration ephemeralSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    
    NSString *searchCity = [city stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSString *urlString = [NSString stringWithFormat:@"http://zipcodedistanceapi.redline13.com/rest/BrFNgZAFZIeKeXCizoFOWAqAO9FjrTO2kuPBtqht8vensQF2flQcVhMKrs3SmSVG/city-zips.json/%@/%@", searchCity, state];
    
    //        NSLog(@"%@", urlString);
    
    NSURLSessionDataTask *dataTask = [[NSURLSessionHelper getNSURLSession] dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSNumber *zipNumber;
        if (!error) {
            NSDictionary *zipDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            NSArray *array = [zipDictionary objectForKey:@"zip_codes"];
            
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setNumberStyle:NSNumberFormatterNoStyle];
            zipNumber = [formatter numberFromString:array[0]];
        } else {
            zipNumber = @0;
        }
        
        if ([sender isKindOfClass:[Connection class]]) {
            connection.zipCode = zipNumber;
//            [CoreDataHelper saveContext];
            
        } else {
            worker.zipCode = zipNumber;
//            [CoreDataHelper saveContext];
        }
        
    }];
    
    [dataTask resume];
}

@end
