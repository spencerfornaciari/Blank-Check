//
//  NoteTableViewCell.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 8/13/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "NoteTableViewCell.h"

@implementation NoteTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
    // Configure the view for the selected state
}

-(void)setCell:(Note *)note {
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", note.connection.firstName, note.connection.lastName];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    NSString *dateString = [dateFormat stringFromDate:note.date];
    
    self.dateLabel.text = dateString;
    
    self.noteLabel.text = note.comments;
    self.noteLabel.numberOfLines = 0;
    [self.noteLabel sizeToFit];
}

@end
