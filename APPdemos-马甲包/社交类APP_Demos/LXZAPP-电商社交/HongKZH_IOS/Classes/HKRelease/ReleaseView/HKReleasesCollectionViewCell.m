//
//  HKReleasesCollectionViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/18.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKReleasesCollectionViewCell.h"
#import "UIImageView+HKWeb.h"
@interface HKReleasesCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *name;

@end

@implementation HKReleasesCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(AllcategorysModel *)model{
    _model = model;
    [self.iconView hk_sd_setImageWithURL:model.imgSrc placeholderImage:kPlaceholderImage];
    self.name.text = model.name;
}
@end
