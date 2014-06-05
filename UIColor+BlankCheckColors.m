//
//  UIColor+BlankCheckColors.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 6/5/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "UIColor+BlankCheckColors.h"

@implementation UIColor (BlankCheckColors)

+(UIColor *)blankCheckBlue{
    float red = 68.0/255.0;
    float green = 116.0/255.0;
    float blue = 157.0/255.0;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

+(UIColor *)blankCheckLightBlue{
    float red = 198.0/255.0;
    float green = 212.0/255.0;
    float blue = 225.0/255.0;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

+(UIColor *)blankCheckTan{
    float red = 235.0/255.0;
    float green = 231.0/255.0;
    float blue = 224.0/255.0;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

+(UIColor *)blankCheckBrown{
    float red = 189.0/255.0;
    float green = 184.0/255.0;
    float blue = 173.0/255.0;

    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

@end
