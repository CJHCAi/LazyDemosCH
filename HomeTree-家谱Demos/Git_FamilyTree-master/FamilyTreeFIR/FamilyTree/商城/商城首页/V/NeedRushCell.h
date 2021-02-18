//
//  NeedRushCell.h
//  ListV
//
//  Created by imac on 16/7/26.
//  Copyright © 2016年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NeedRushCell : UICollectionViewCell
/**
 *  商品名
 */
@property (strong,nonatomic) UILabel *goodNameLb;
/**
 *  商品图标
 */
@property (strong,nonatomic) UIImageView *goodIV;
/**
 *  实付价格
 */
@property (strong,nonatomic) UILabel *payMoneyLb;
/**
 *  商品报价
 */
@property (strong,nonatomic) UILabel *quoteLb;


/**商品id*/
@property (nonatomic,strong) NSString *goodId;
/**商品类型id*/
@property (nonatomic,strong) NSString *goodTypeId;

@end
