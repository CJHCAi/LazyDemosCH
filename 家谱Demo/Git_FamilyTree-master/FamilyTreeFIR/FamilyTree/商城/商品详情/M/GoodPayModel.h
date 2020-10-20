//
//  GoodPayModel.h
//  ListV
//
//  Created by imac on 16/7/27.
//  Copyright © 2016年 imac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodPayModel : NSObject
/**
 *  商品名称
 */
@property (strong,nonatomic) NSString *goodName;
/**
 *  商品实付价格
 */
@property (strong,nonatomic) NSString *goodMoney;
/**
 *  商品颜色
 */
@property (strong,nonatomic) NSString *goodColor;
/**
 *  商品款式
 */
@property (strong,nonatomic) NSString *goodStyle;
/**
 *  商品款式id
 */
@property (strong,nonatomic) NSString *goodStyleId;
/**
 *  商品数量
 */
@property (strong,nonatomic) NSString *goodCount;

@end
