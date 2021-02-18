//
//  HotActiVeCell.h
//  ListV
//
//  Created by imac on 16/7/22.
//  Copyright © 2016年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotActiVeCell : UICollectionViewCell
/**
 *  商品名字
 */
@property (strong,nonatomic) UILabel *goodNameLb;
/**
 *  实际价格
 */
@property (strong,nonatomic) UILabel *payMoneyLb;
/**
 *  报价
 */
@property (strong,nonatomic) UILabel *quoteLb;
/**
 *  商品图标
 */
@property (strong,nonatomic) UIImageView *goodIV;

/**商品id*/
@property (nonatomic,strong) NSString *goodId;
/**商品类型id*/
@property (nonatomic,strong) NSString *goodTypeId;


@end
