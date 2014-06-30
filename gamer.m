//
//  Gamer.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 5/28/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "Gamer.h"

@implementation Gamer

-(instancetype)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init])
    {
//        self.title = [decoder decodeObjectForKey:@"title"];
//        self.mpaaRating = [decoder decodeObjectForKey:@"mpaaRating"];

        
        return self;
    }
    
    return nil;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
//    [encoder encodeObject:self.title forKey:@"title"];
//    [encoder encodeObject:self.mpaaRating forKey:@"mpaaRating"];

}
@end
