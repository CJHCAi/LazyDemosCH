//
//  YFShopCell.m
//  BigShow1949
//
//  Created by 杨帆 on 15-9-2.
//  Copyright (c) 2015年 BigShowCompany. All rights reserved.
//

#import "YFShopCell.h"
#import "JDShopModel.h"
#import "UIImageView+WebCache.h"

@interface YFShopCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@end


@implementation YFShopCell

- (void)setShop:(JDShopModel *)shop
{
    _shop = shop;
    
    self.priceLabel.text = shop.price;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:shop.img] placeholderImage:[UIImage imageNamed:@"i5"]];
}

@end
