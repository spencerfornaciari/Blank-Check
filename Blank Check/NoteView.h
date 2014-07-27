//
//  NoteView.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/27/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteView : UIView <UITextFieldDelegate>

@property (nonatomic) UITextField *textField;
@property (nonatomic) UIButton *saveButton;


@end
