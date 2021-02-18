//
//  ShopOrderView.h
//  ListV
//
//  Created by imac on 16/8/1.
//  Copyright © 2016年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopOrderView : UIView
/**
 *  商品图片
 */
@property (strong,nonatomic) UIImageView *goodIV;
/**
 *  商品名称
 */
@property (strong,nonatomic) UILabel *goodNameLb;
/**
 *  订单编号
 */
@property (strong,nonatomic) UILabel *orderNOLb;
/**
 *  价格
 */
@property (strong,nonatomic) UILabel *moneyLb;
/**
 *  报价
 */
@property (strong,nonatomic) UILabel *quoteLb;
/**
 *  数量
 */
@property (strong,nonatomic) UILabel *countLb;


@end
