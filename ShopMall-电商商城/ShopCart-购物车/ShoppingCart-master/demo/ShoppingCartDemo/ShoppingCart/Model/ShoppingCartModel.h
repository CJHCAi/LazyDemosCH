//
//  ShoppingCartModel.h
//  ShoppingCartDemo
//
//  Created by dry on 2017/12/3.
//  Copyright © 2017年 MorrisMeng. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ShopModel;
@class GoodsModel;

//购物车模型
@interface ShoppingCartModel : NSObject

//@property (nonatomic, assign) BOOL allSelected;//是否全选
//@property (nonatomic, strong) NSArray <__kindof ShopModel *> *shops;//所有店铺

//请求店铺数据，处理数据并返回结果
+ (void)requestDataWithSucess:(void(^)(NSArray <__kindof ShopModel *>*result))sucess failure:(void(^)(void))failure;

@end




//店铺模型
@interface ShopModel : NSObject

@property (nonatomic, strong) NSString *shopId;//店铺ID
@property (nonatomic, strong) NSString *shopName;//店铺名
@property (nonatomic, assign) BOOL isSelected;//整个section的商品是否被选中
@property (nonatomic, strong) NSArray <__kindof GoodsModel *> *goods;//商品列表

@end



//商品模型
@interface GoodsModel : NSObject

@property (nonatomic, strong) NSString *goodsId;//商品ID
@property (nonatomic, strong) NSString *count;//商品数量
@property (nonatomic, strong) NSString *goodsName;//商品名称
@property (nonatomic, strong) NSString *price;//商品价格
@property (nonatomic, strong) NSString *imageUrl;//商品图片连接
@property (nonatomic, assign) BOOL isSelected;//商品是否被选

@end
