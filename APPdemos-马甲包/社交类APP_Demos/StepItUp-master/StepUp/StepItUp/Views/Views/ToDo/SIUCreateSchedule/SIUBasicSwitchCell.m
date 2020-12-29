//
//  SIUBasicSwitchCell.m
//  Step it up
//
//  Created by syfll on 15/4/4.
//  Copyright (c) 2015年 syfll. All rights reserved.
//

#import "SIUBasicSwitchCell.h"

@implementation SIUBasicSwitchCell

+(SIUBasicSwitchCell*) CreateCell{
    SIUBasicSwitchCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"SIUBasicSwitchCell" owner:self options:nil] objectAtIndex:0];
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
