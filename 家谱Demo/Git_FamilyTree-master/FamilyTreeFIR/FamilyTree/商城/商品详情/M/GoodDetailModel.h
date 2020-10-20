//
//  GoodDetailModel.h
//  ListV
//
//  Created by imac on 16/7/27.
//  Copyright © 2016年 imac. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GoodColorModel,GoodStyleModel;
@interface GoodDetailModel : NSObject
/**
 *  商品名称
 */
@property (strong,nonatomic) NSString *goodName;
/**
 *  商品实付价格
 */
@property (strong,nonatomic) NSString *goodMoney;
/**
 *  商品报价
 */
@property (strong,nonatomic) NSString *goodQuote;

@property (strong,nonatomic) NSMutableArray<GoodColorModel*> *colorList;

@property (strong,nonatomic) NSMutableArray<GoodStyleModel *> *styleList;
/**
 *  商品数量
 */
@property (strong,nonatomic) NSString *goodCount;
@end

@interface GoodColorModel : NSObject
/**
 *  商品颜色
 */
@property (strong,nonatomic) NSString *goodColor;

@end

@interface GoodStyleModel : NSObject
/**
 *  商品款式
 */
@property (strong,nonatomic) NSString *goodStyle;

@end