//
//  NoteView.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/27/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "NoteView.h"

@implementation NoteView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.textField = [[UITextField alloc] initWithFrame:self.frame];
        self.textField.delegate = self;
        
        
        self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    return TRUE;
}

@end
