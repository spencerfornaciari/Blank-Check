//
//  LocationController.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 8/21/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "CoreDataHelper.h"
#import "Worker.h"
#import "Connection.h"

@interface LocationController : NSObject

+(void)getLocationData:(id)sender;
+(void)getZipCode:(id)sender;

@end
