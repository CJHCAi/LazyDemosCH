//
//  HKEnterpriseProductsCollectionViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/11/8.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKEnterpriseProductsCollectionViewCell.h"
#import "UIImageView+HKWeb.h"
@interface HKEnterpriseProductsCollectionViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end

@implementation HKEnterpriseProductsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconView.layer.cornerRadius = 5;
    self.iconView.layer.masksToBounds = YES;
    // Initialization code
}
-(void)setModel:(HKAdvDetailsProducts *)model{
    _model = model;
    self.titleLabel.text = model.title;
    [self.iconView hk_sd_setImageWithURL:model.imgSrc placeholderImage:kPlaceholderImage];
}
@end
