//
//  GoodsModel.h
//  JGTaoBaoShopping
//
//  Created by 郭军 on 2017/3/16.
//  Copyright © 2017年 ZJNY. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GoodsInfoModel;

@interface GoodsModel : NSObject

//店铺名称
@property (nonatomic, copy)NSString *StoreName;
/**
 *  判断section是否被选中
 */
@property (nonatomic, copy)NSString *SelectedSection;
/**
 *  判断编辑按钮
 */
@property (nonatomic, copy)NSString *SelectedSectionEdit;

//每个店铺下是商品种类
@property (nonatomic, copy)NSArray <GoodsModel *>* ListGoods;

@end
/*******************************      商品信息         **************************************/

@interface GoodsInfoModel : NSObject

//商品图片
@property (nonatomic, copy)NSString *Goods_Icon;
//商品名称
@property (nonatomic, copy)NSString *Goods_Title;
//商品的描述
@property (nonatomic, copy)NSString *Goods_Desc;
//商品的出售价格
@property (nonatomic, copy)NSString *Goods_Price;
//商品的原价格
@property (nonatomic, copy)NSString *Goods_OldPrice;
//商品的购买数量
@property (nonatomic, copy)NSString *Goods_Number;

/**
 *  判断商品是否被选中
 */
@property (nonatomic, copy)NSString *SelectedRow_goods;


@end

