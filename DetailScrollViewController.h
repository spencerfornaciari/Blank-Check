//
//  DetailScrollViewController.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 6/23/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Gamer.h"

@interface DetailScrollViewController : UIViewController <UIScrollViewDelegate> {
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIImageView *profileImage;
    IBOutlet UILabel *userNameLabel;
    IBOutlet UILabel *valueLabel;
    
    

    
    IBOutlet UILabel *workExpLabel;
    IBOutlet UILabel *educationExpLabel;
    
    
}

@property (nonatomic) Gamer *gamer;

@end
