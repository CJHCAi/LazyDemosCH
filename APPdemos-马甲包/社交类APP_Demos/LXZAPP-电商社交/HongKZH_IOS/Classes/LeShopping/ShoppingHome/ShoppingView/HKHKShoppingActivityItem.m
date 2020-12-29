//
//  HKHKShoppingActivityItem.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/18.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKHKShoppingActivityItem.h"
#import "HKCateroyShopTableViewCell.h"
#import "UIImageView+HKWeb.h"
@interface HKHKShoppingActivityItem()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleV;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *Original;
@property (weak, nonatomic) IBOutlet UILabel *originalPrece;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *originaH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *originaTop;

@end

@implementation HKHKShoppingActivityItem

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(HKLeShopHomeLuckyvouchers *)model{
    _model = model;
    self.line.hidden = NO;
    self.originalPrece.hidden = NO;
    self.Original.hidden = NO;
    self.originaH.constant = 14;
    self.originaTop.constant = 26;
    [self.iconView hk_sd_setImageWithURL:model.imgSrc placeholderImage:kPlaceholderImage];
    self.titleV.text = model.title;
    self.originalPrece.text = [NSString stringWithFormat:@"%.2f",model.integral] ;
    self.price.text = [NSString stringWithFormat:@"%ld",model.discountIntegral];
}
-(void)setProductsM:(HKLeShopHomeToSelectedproducts *)productsM{
    _productsM = productsM;
    self.line.hidden = YES;
    self.originalPrece.hidden = NO;
//    self.Original.hidden = YES;
    self.originaH.constant = 0;
    self.originaTop.constant = 15;
    [self.iconView hk_sd_setImageWithURL:productsM.imgSrc placeholderImage:kPlaceholderImage];
    self.titleV.text = productsM.title;
    self.price.text = [NSString stringWithFormat:@"¥ %.2f",productsM.integral];
}
-(void)setVideoProduct:(GetMediaAdvAdvByIdProducts *)videoProduct{
    _videoProduct = videoProduct;
    self.line.hidden = YES;
    self.originalPrece.hidden = NO;
    //    self.Original.hidden = YES;
    self.originaH.constant = 0;
    self.originaTop.constant = 15;
    [self.iconView hk_sd_setImageWithURL:videoProduct.imgSrc placeholderImage:kPlaceholderImage];
    self.titleV.text = videoProduct.title;
    self.price.text = [NSString stringWithFormat:@"¥%ld",videoProduct.price];
}
@end
