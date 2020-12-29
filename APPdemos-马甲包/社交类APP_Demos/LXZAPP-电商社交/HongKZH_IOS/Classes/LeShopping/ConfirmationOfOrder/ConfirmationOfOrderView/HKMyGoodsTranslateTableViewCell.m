//
//  HKMyGoodsTranslateTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyGoodsTranslateTableViewCell.h"
#import "HKDiscountView.h"
#import "UIImageView+HKWeb.h"
@interface HKMyGoodsTranslateTableViewCell()
@property (nonatomic,weak) IBOutlet UIImageView *iconView;
@property (nonatomic,weak) IBOutlet UILabel *titleView;
@property (nonatomic,weak) IBOutlet UILabel *timeView;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *discontViewW;
@property (nonatomic,weak) IBOutlet HKDiscountView *discontView;
@end

@implementation HKMyGoodsTranslateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIImage*image = [UIImage imageNamed:@"xrzx_zk"];
    self.discontViewW.constant = image.size.width;
}
-(void)setModel:(HKCounList *)model{
    _model = model;
    [self.iconView hk_sd_setImageWithURL:model.imgSrc placeholderImage:kPlaceholderImage];
    self.titleView.text = model.title;
    self.timeView.text = [NSString stringWithFormat:@"%@-%@",model.beginTime,model.endTime];
    self.discontView.discount = model.discount;
}
@end
