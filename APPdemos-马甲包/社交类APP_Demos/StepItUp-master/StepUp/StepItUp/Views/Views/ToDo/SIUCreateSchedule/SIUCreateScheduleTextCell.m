//
//  SIUCreateScheduleTextCell.m
//  Step it up
//
//  Created by syfll on 15/4/3.
//  Copyright (c) 2015年 syfll. All rights reserved.
//

#import "SIUCreateScheduleTextCell.h"

@implementation SIUCreateScheduleTextCell


+ (SIUCreateScheduleTextCell*) CreateCell
{
    SIUCreateScheduleTextCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"SIUCreateScheduleTextCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.isFirstEditing = false;
    cell.ReminderTextView.textColor = [UIColor grayColor];
    return cell;
}
- (void)awakeFromNib {
    self.ReminderTextView.delegate = self;
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (!self.isFirstEditing) {
        self.ReminderTextView.text = @"";
        self.ReminderTextView.textColor = [UIColor blackColor];
        self.isFirstEditing = true;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
