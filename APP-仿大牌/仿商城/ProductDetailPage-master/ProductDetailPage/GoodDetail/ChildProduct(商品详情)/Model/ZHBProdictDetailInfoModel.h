//
//  ZHBProdictDetailInfoModel.h
//  ZhongHeBao
//
//  Created by 云无心 on 16/12/29.
//  Copyright © 2016年 zhbservice. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "APXTipModel.h"
// product,名字取错,有时间替换..fsstodo
@interface ZHBProdictDetailInfoModel : NSObject

@property (nonatomic, copy) NSString *productDetailId;
@property (nonatomic, copy) NSArray  *productImages; // banner(不同子产品不同banner)
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *stockNumber; // 库存
@property (nonatomic, copy) NSString *oldPoints; // 老积分值
@property (nonatomic, copy) NSString *points; // 积分值
@property (nonatomic, copy) NSString *discountPoints;
@property (nonatomic, copy) NSString *oldPrice; // 划线价格

@property (nonatomic, assign) BOOL  favorited;

// 跟着子商品走

// 领券
@property (nonatomic, strong) APXTipModel *coupon; // 领券
// 优惠
@property (nonatomic, strong) APXTipModel *sale; // 优惠

/*****  服务说明  ****/
// 服务说明
@property (nonatomic, strong) NSMutableArray *serviceList; // 服务说明数组返回
@property (nonatomic, copy) NSString *serviceURL; // 服务说明H5网址

// 服务说明
@property (nonatomic, strong) APXTipModel *service; // 服务说明

// 配置
@property (nonatomic, strong) APXTipModel *config; // 配置
// 购买须知
@property (nonatomic, strong) APXTipModel *purchaseNotes; // 购买须知


@end
