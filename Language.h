//
//  Languages.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 5/29/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Language : NSObject

@property (nonatomic) NSString *languageID;
@property (nonatomic) NSString *languageName;
@property (nonatomic) NSInteger *languageProficiency;

@end
