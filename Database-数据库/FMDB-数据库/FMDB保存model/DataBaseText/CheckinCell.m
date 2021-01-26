//
//  CheckinCell.m
//  DataBaseText
//
//  Created by 劳景醒 on 16/12/14.
//  Copyright © 2016年 laojingxing. All rights reserved.
//

#import "CheckinCell.h"

@implementation CheckinCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(CheckinModel *)model
{
    if (_model != model) {
        _model = model;
        
        _nameLabel.text = model.flightName;
        _flightCodeLabel.text = model.flightCode;
        _rulerLabel.text = model.flightTimeAndRule;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
