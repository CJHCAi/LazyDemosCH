//
//  ShoppingCartModel.m
//  ShoppingCartDemo
//
//  Created by dry on 2017/12/3.
//  Copyright © 2017年 MorrisMeng. All rights reserved.
//

#import "ShoppingCartModel.h"

@implementation ShoppingCartModel

+ (void)requestDataWithSucess:(void(^)(NSArray <__kindof ShopModel *>*result))sucess failure:(void(^)(void))failure
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ShopCartList" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    if (dict)
    {
        NSLog(@"%@",dict);
        
        NSArray *shops = dict[@"data"];
        //存储店铺模型的数组
        NSMutableArray *shoppingCartArray = [[NSMutableArray alloc] init];
        for (NSDictionary *shop in shops)
        {
            ShopModel *shopModel = [[ShopModel alloc] init];
            shopModel.shopId = shop[@"shopId"];
            shopModel.shopName = shop[@"shopName"];
            shopModel.isSelected = [shop[@"isSelected"] integerValue];
            
            NSArray *goods = shop[@"goods"];
            //存储商品模型的数组
            NSMutableArray *goosArray = [[NSMutableArray alloc] init];
            for (NSDictionary *goodsDict in goods)
            {
                GoodsModel *goodsModel = [[GoodsModel alloc] init];
                goodsModel.goodsId = goodsDict[@"goodsId"];
                goodsModel.goodsName = goodsDict[@"goodsName"];
                goodsModel.count = goodsDict[@"count"];
                goodsModel.price = goodsDict[@"price"];
                goodsModel.imageUrl = goodsDict[@"imageUrl"];
                goodsModel.isSelected = [goodsDict[@"isSelected"] integerValue];
                
                [goosArray addObject:goodsModel];
            }
            
            shopModel.goods = goosArray;
            
            [shoppingCartArray addObject:shopModel];
        }
        
        if (sucess) {
            sucess(shoppingCartArray);
        }
        
    } else {
        if (failure)(nil);
    }
}

@end




@implementation ShopModel

@end




@implementation GoodsModel

@end

