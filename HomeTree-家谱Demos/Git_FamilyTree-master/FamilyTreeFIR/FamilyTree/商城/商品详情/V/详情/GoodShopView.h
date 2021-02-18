//
//  GoodShopView.h
//  ListV
//
//  Created by imac on 16/7/26.
//  Copyright © 2016年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodPayModel.h"
#import "GoodDetailModel.h"

@interface GoodShopView : UIView
/**
 *  商品名
 */
@property (strong,nonatomic) UILabel *goodNameLb;
/**
 *  实付价格
 */
@property (strong,nonatomic) UILabel *payMoneyLb;
/**
 *  报价
 */
@property (strong,nonatomic) UILabel *quoteLb;

/**
 *  选中的商品
 */
@property (strong,nonatomic) GoodPayModel *goodPayModel;
/**
 *  视图赋值
 */
- (void)getGoodData:(GoodDetailModel *)sender;

@property (nonatomic) CGFloat height;

- (void)updateFrame;
@end
