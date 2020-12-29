//
//  HKShoppingViewModel.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewModel.h"
@class HKLeShopHomeRespone,HKUserCategoryListRespone,HKSubCategoryListRespone,HKLuckyBurstRespone,HKLuckyBurstRespone,HKLuckyBurstListRespone,HKluckyBurstDetailRespone,SearchGoodsRespone,LuckyBurstFriendsRespone,CategoryProductListRespone;
@interface HKShoppingViewModel : HKBaseViewModel
+(void)getRecruitInfoSuccess:(void (^)( HKLeShopHomeRespone* responde))success;
+(void)getCategoryListSuccess:(void (^)( HKUserCategoryListRespone* responde))success;
+(void)getSubCategoryList:(NSDictionary*)dict success:(void (^)( HKSubCategoryListRespone* responde))success;
+(void)getLuckyBurst:(NSDictionary*)dict success:(void (^)( HKLuckyBurstRespone* responde))success;
+(void)getLuckyBurstList:(NSDictionary*)dict success:(void (^)( HKLuckyBurstListRespone* responde))success;
+(void)buyLuckyBurst:(NSDictionary*)dict success:(void (^)( HKBaseResponeModel* responde))success;
+(void)luckyBurstDetail:(NSDictionary*)dict success:(void (^)( HKluckyBurstDetailRespone* responde))success;
+(void)shopSearchProductHistory:(NSDictionary*)dict success:(void (^)( SearchGoodsRespone* responde))success;
+(void)searchProduct:(NSDictionary*)dict success:(void (^)(NSMutableArray*dataArray))success;
+(void)getLuckyBurstByAdv:(NSDictionary*)dict success:(void (^)( HKBaseResponeModel* responde))success;
+(void)getLuckyBurstByFriend:(NSDictionary*)dict success:(void (^)( HKBaseResponeModel* responde))success;
+(void)mediaShopCartCountSuccess:(void (^)( HKBaseResponeModel* responde))success;
+(void)deleteCartByid:(NSDictionary*)dict success:(void (^)( HKBaseResponeModel* responde))success;
+(void)getLuckyBurstFriends:(NSDictionary*)dict success:(void (^)( LuckyBurstFriendsRespone* responde))success;
+(void)getbottomProductList:(NSDictionary*)dict success:(void (^)( CategoryProductListRespone* responde))success;
@end
