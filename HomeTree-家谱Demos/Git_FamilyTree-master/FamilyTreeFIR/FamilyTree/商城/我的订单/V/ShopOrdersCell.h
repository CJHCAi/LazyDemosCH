//
//  ShopOrdersCell.h
//  ListV
//
//  Created by imac on 16/8/1.
//  Copyright © 2016年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopOrderView.h"
#import "ShopActionView.h"
#import "ShopGoodModel.h"

@protocol ShopOrdersCellDelegate <NSObject>

- (void)orderAction:(NSString *)order action:(UIButton *)sender;

- (void)orderActionWithNumber:(NSString *)orderNumber action:(UIButton *)sender;

@end

@interface ShopOrdersCell : UITableViewCell
/**
 *  日期
 */
@property (strong,nonatomic) UILabel *dateLb;
/**
 *  状态
 */
@property (strong,nonatomic) UILabel *statusLb;


/**
 *  按钮视图
 */
@property (strong,nonatomic) ShopActionView *shopActionV;

/**
 *  总件数
 */
@property (strong,nonatomic) UILabel *totalLb;
/**
 *  支付总额
 */
@property (strong,nonatomic) UILabel *allPayLb;
/**订单号*/
@property (nonatomic,strong) NSString *orderNumber;


/**
 *  根据获取订单商品类型数量改变布局
 *
 *  @param data 订单数据
 */
- (void)initShopView:(ShopGoodModel *)data;

@property (weak,nonatomic) id<ShopOrdersCellDelegate>delegate;

@end
