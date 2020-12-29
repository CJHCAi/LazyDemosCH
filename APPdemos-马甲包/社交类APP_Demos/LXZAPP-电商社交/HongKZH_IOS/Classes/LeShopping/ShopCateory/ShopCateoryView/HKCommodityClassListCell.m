//
//  HKCommodityClassListCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCommodityClassListCell.h"
#import "UIImage+YY.h"
#import "UIImageView+HKWeb.h"
#import "TopLeftLabel.h"
@interface HKCommodityClassListCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet TopLeftLabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *num;
@property (weak, nonatomic) IBOutlet UIButton *voucher;

@end

@implementation HKCommodityClassListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIImage *image = [UIImage createImageWithColor:[UIColor colorFromHexString:@"FC8872"] size:CGSizeMake(65, 15)];
    image = [image zsyy_imageByRoundCornerRadius:7.5];
    [self.voucher setBackgroundImage:image forState:0];
}
-(void)setModel:(CategoryProductListModels *)model{
    _model = model;
    if (model.couponCount>0) {
        self.voucher.hidden = NO;
    }else{
        self.voucher.hidden = NO;
    }
    self.titleView.text = model.title;
    self.num.text = [NSString stringWithFormat:@"%.2lf",model.integral];
    [self.iconView hk_sd_setImageWithURL:model.imgSrc placeholderImage:kPlaceholderImage];
}
@end
