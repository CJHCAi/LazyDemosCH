//
//  HKShopItem.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/18.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKShopItem.h"
#import "UIImageView+HKWeb.h"
#import "UIView+BorderLine.h"
@interface HKShopItem()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *name;

@end

@implementation HKShopItem

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.iconView borderForColor:[UIColor colorFromHexString:@"e2e2e2"] borderWidth:1 borderType:UIBorderSideTypeAll];
    // Initialization code
}
-(void)setShopM:(HKLeShopHomeShopes *)shopM{
    _shopM = shopM;
    [self.iconView hk_sd_setImageWithURL:shopM.imgSrc placeholderImage:kPlaceholderImage];
    self.name.text = shopM.name;
}
@end
