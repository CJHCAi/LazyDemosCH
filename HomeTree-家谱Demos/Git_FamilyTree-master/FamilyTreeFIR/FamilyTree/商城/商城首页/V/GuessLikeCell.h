//
//  GuessLikeCell.h
//  ListV
//
//  Created by imac on 16/7/26.
//  Copyright © 2016年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuessLikeCell : UICollectionViewCell
/**
 *  商品图片
 */
@property (strong,nonatomic) UIImageView *goodIV;
/**
 *  商品名称
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
 *  购物车按钮
 */
@property (strong,nonatomic) UIButton *shoppingBtn;
/**商品id*/
@property (nonatomic,strong) NSString *goodId;
/**商品类型id*/
@property (nonatomic,strong) NSString *goodTypeId;
@end
