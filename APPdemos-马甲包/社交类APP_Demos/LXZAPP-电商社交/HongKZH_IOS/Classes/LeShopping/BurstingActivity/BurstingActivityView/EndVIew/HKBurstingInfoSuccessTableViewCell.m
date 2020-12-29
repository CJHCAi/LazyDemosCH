//
//  HKBurstingInfoSuccessTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/19.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBurstingInfoSuccessTableViewCell.h"
#import "UIView+BorderLine.h"
#import "HKDiscountView.h"
#import "HKluckyBurstDetailRespone.h"
#import "UIImageView+HKWeb.h"
@interface HKBurstingInfoSuccessTableViewCell()
@property (weak, nonatomic) IBOutlet UIButton *UseBtn;
@property (weak, nonatomic) IBOutlet UIButton *SellBtn;
@property (weak, nonatomic) IBOutlet UIImageView *iconVIew;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet HKDiscountView *discount;
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *discountW;

@end

@implementation HKBurstingInfoSuccessTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.UseBtn borderForColor:[UIColor colorFromHexString:@"EF593C "] borderWidth:1 borderType:UIBorderSideTypeAll];
    [self.SellBtn borderForColor:[UIColor colorFromHexString:@"EF593C "] borderWidth:1 borderType:UIBorderSideTypeAll];
    UIImage *image = [UIImage imageNamed:@"xrzx_zk"];
    self.discountW.constant = image.size.width;
}
-(void)setRespone:(HKluckyBurstDetailRespone *)respone{
    _respone = respone;
    self.titleView.text = respone.data.title;
    [self.iconVIew hk_sd_setImageWithURL:respone.data.imgSrc placeholderImage:kPlaceholderImage];
    self.price.text = [NSString stringWithFormat:@"商品原价：%.2lf",respone.data.integral];
    self.discount.discount = respone.data.discount;
}
@end
