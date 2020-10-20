//
//  OrderGoodCell.h
//  ListV
//
//  Created by imac on 16/8/2.
//  Copyright © 2016年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderGoodCell : UITableViewCell
/**
 *  商品图片
 */
@property (strong,nonatomic) UIImageView *goodIV;
/**
 *  商品名称
 */
@property (strong,nonatomic) UILabel *goodNameLb;
/**
 *  价格
 */
@property (strong,nonatomic) UILabel *goodMoneyLb;
/**
 *  数量
 */
@property (strong,nonatomic) UILabel *goodCountLb;

@end
