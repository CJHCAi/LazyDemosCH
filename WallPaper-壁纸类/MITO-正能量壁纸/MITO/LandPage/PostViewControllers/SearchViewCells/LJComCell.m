//
//  LJComCell.m
//  FitnessHelper
//
//  Created by 成都千锋 on 15/10/29.
//  Copyright (c) 2015年 成都千锋. All rights reserved.
//

#import "LJComCell.h"
#import <UIImageView+WebCache.h>

@implementation LJComCell

- (void)setModel:(LJCollectionObjectModel *)model {
    _model = model;
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",model.baseurl,model.link]] placeholderImage:[UIImage imageNamed:@"LBLoadError.jpg"]];
    self.descLabel.text = model.name;
    self.numLabel.text = [NSString stringWithFormat:@"下载:%@",model.downnum];
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

@end
