//
//  SIUCreateScheduleDatePickerCell.m
//  Step it up
//
//  Created by syfll on 15/4/3.
//  Copyright (c) 2015年 syfll. All rights reserved.
//

#import "SIUCreateScheduleDatePickerCell.h"

@implementation SIUCreateScheduleDatePickerCell

#pragma mark -
#pragma mark Init Methods

+ (SIUCreateScheduleDatePickerCell*) CreateCell
{
    SIUCreateScheduleDatePickerCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"SIUCreateScheduleDatePickerCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
