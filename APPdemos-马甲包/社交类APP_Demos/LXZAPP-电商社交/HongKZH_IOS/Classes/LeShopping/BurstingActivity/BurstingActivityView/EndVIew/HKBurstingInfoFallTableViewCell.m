//
//  HKBurstingInfoFallTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/19.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBurstingInfoFallTableViewCell.h"
#import "HKluckyBurstDetailRespone.h"
#import "UIImageView+HKWeb.h"
#import "HKDiscountView.h"
@interface HKBurstingInfoFallTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet HKDiscountView *discount;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *discountW;

@end

@implementation HKBurstingInfoFallTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIImage *image = [UIImage imageNamed:@"xrzx_zk"];
    self.discountW.constant = image.size.width;
}
-(void)setRespone:(HKluckyBurstDetailRespone *)respone{
    _respone = respone;
    self.titleView.text = respone.data.title;
    [self.iconView hk_sd_setImageWithURL:respone.data.imgSrc placeholderImage:kPlaceholderImage];
    self.price.text = [NSString stringWithFormat:@"商品原价：%.2lf",respone.data.integral];
    self.discount.discount = respone.data.discount;
}
@end
