//
//  LJTableCell.m
//  FitnessHelper
//
//  Created by 成都千锋 on 15/10/31.
//  Copyright (c) 2015年 成都千锋. All rights reserved.
//

#import "LJTableCell.h"
#import <UIImageView+WebCache.h>
//#import "LJDBManager.h"

@implementation LJTableCell

- (void)setModel:(LJTableViewModel *)model {
    _model = model;
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",model.baseurl,model.thumb1]] placeholderImage:[UIImage imageNamed:@"playHoder"]];
    self.titleLabel.text = model.name;
    self.authorLabel.text = [NSString stringWithFormat:@"作者:%@",model.author.length? model.author:@"壁纸多多"];
    self.descLabel.text = [NSString stringWithFormat:@"简介:%@",model.desc];
    [self.smallImage1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",model.baseurl,model.thumb2]] placeholderImage:[UIImage imageNamed:@"playHoder"]];
    [self.smallImage2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",model.baseurl,model.thumb3]] placeholderImage:[UIImage imageNamed:@"playHoder"]];
    [self.smallImage3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",model.baseurl,model.thumb4]] placeholderImage:[UIImage imageNamed:@"playHoder"]];
    UIImage *image = [UIImage imageNamed:@"btn_yellowdiamond"];
    image = [image stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    [self.collectButton setBackgroundImage:image forState:UIControlStateNormal];
    [self.collectButton setTitle:@"收藏" forState:UIControlStateNormal];
    [self.collectButton addTarget:self action:@selector(collectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)collectButtonClicked:(UIButton *)button {

       [button setTitle:@"已收藏" forState:UIControlStateNormal];

}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
