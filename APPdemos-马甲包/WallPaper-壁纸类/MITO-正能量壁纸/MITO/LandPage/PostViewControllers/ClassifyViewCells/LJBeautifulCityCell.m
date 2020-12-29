//
//  LJBeautifulCityCell.m
//  FitnessHelper
//
//  Created by 成都千锋 on 15/10/27.
//  Copyright (c) 2015年 成都千锋. All rights reserved.
//

#import "LJBeautifulCityCell.h"
#import <UIImageView+WebCache.h>

@implementation LJBeautifulCityCell

- (void)setModel:(LJBeautifulCityModel *)model {
    _model = model;
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:_model.thumb] placeholderImage:[UIImage imageNamed:@"playHoder"]];
    self.addressLabel.text = _model.name;
    self.numberLabel.text = [NSString stringWithFormat:@"更新:%@",_model.update_num];
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
}

@end
