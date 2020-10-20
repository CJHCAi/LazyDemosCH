//
//  ShopGoodModel.h
//  ListV
//
//  Created by imac on 16/8/1.
//  Copyright © 2016年 imac. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GoodCarModel;

@interface ShopGoodModel : NSObject
/**
 *  日期
 */
@property (strong,nonatomic) NSString *date;
/**
 *  状态
 */
@property (strong,nonatomic) NSString *status;
/**
 *  总数量
 */
@property (strong,nonatomic) NSString *totalCount;
/**
 *  总金额
 */
@property (strong,nonatomic) NSString *totalMoney;
/**
 *  运费
 */
@property (strong,nonatomic) NSString *freight;

@property (strong,nonatomic) NSMutableArray<GoodCarModel *> *goodArr;

@end

@interface GoodCarModel : NSObject
/**
 *  商品图片
 */
@property (strong,nonatomic) NSString *goodImg;
/**
 *  商品名称
 */
@property (strong,nonatomic) NSString *goodName;
/**
 *  商品价格
 */
@property (strong,nonatomic) NSString *goodMoney;
/**
 *  商品报价
 */
@property (strong,nonatomic) NSString *goodQuote;
/**
 *  商品订单号
 */
@property (strong,nonatomic) NSString *orderNo;
/**
 *  商品数量
 */
@property (strong,nonatomic) NSString *goodcount;
/**订单id*/
@property (nonatomic,strong) NSString *goodId;


@end



