//
//  LJSearchCell.m
//  FitnessHelper
//
//  Created by 成都千锋 on 15/11/1.
//  Copyright (c) 2015年 成都千锋. All rights reserved.
//

#import "LJSearchCell.h"

@implementation LJSearchCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configData:(NSArray *)array addIndex:(NSInteger)index {
    self.leftLabel.text = [NSString stringWithFormat:@"%ld",index * 2 + 1];
    self.rightLabel.text = [NSString stringWithFormat:@"%ld",(index + 1) * 2];
    [self.leftButton setTitle:array[0] forState:UIControlStateNormal];
    [self.rightButton setTitle:array[1] forState:UIControlStateNormal];
}

- (IBAction)buttonClicked:(UIButton *)sender {
    [self.delegate searchBarTextFromButtonTitle:sender.titleLabel.text];
}
@end
