//
//  HKHKShoppingCategoryItem.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/18.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKHKShoppingCategoryItem.h"
#import "UIImageView+HKWeb.h"
@interface HKHKShoppingCategoryItem()
@property (weak, nonatomic) IBOutlet UIImageView *iconVIew;
@property (weak, nonatomic) IBOutlet UILabel *nameL;

@end

@implementation HKHKShoppingCategoryItem

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(HKLeShopHomeCategoryes *)model{
    _model = model;
    self.iconVIew.layer.masksToBounds = YES;
    self.iconVIew.contentMode =UIViewContentModeScaleAspectFit;
    [self.iconVIew hk_sd_setImageWithURL:model.imgSrc placeholderImage:kPlaceholderImage];
    self.nameL.text = model.categoryName;
}
@end
