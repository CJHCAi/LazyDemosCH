//
//  CommodityDetailsViewModel.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewModel.h"
@class CommodityDetailsRespone,HKShopCateoryParameter,CategoryProductListRespone;
@interface CommodityDetailsViewModel : HKBaseViewModel
+(void)getCommodityDetails:(NSDictionary*)dict success:(void (^)( CommodityDetailsRespone* responde))success;
+(void)getProductSkuBySku:(NSDictionary*)dict success:(void (^)( CommodityDetailsRespone* responde))success;
+(void)getAddCart:(NSDictionary*)dict success:(void (^)( HKBaseResponeModel* responde))success;
+(void)getCategoryProductList:(HKShopCateoryParameter*)parameter success:(void (^)( CategoryProductListRespone* responde))success;
+(void)searchProductList:(NSDictionary*)parameter success:(void (^)( CategoryProductListRespone* responde))success;
+(void)getUserCommodityDetails:(NSDictionary*)dict success:(void (^)( CommodityDetailsRespone* responde))success;
@end
