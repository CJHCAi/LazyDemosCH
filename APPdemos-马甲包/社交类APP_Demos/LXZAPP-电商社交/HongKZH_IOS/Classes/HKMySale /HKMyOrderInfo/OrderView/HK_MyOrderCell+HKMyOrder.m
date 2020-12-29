//
//  HK_MyOrderCell+HKMyOrder.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/1.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_MyOrderCell+HKMyOrder.h"
#import "UIImageView+HKWeb.h"
#import <objc/runtime.h>
static char *infoModelKey = "infoModel";
@implementation HK_MyOrderCell (HKMyOrder)
/*
 * 对象类型
 */
- (void)setInfoModel:(HKOrderInfoData *)infoModel {
    
    objc_setAssociatedObject(self, &infoModelKey, infoModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    SubModellist*sub = infoModel.subList.firstObject;
    [self.iconImageView hk_sd_setImageWithURL:sub.imgSrc placeholderImage:kPlaceholderImage];
    self.goodNameLabel.text = sub.title;
    self.goodColorLabel.text = sub.specName;
    self.ShopNumberLabel.text = [NSString stringWithFormat:@"x %ld",sub.number];
    self.MycountLabel.text = [NSString stringWithFormat:@"%ld",sub. integral];
}

- (NSString *)infoModel {
    
    return objc_getAssociatedObject(self, &infoModelKey);
}

@end
