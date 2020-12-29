//
//  HKShoppingViewModel.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKShoppingViewModel.h"
#import "HKLeShopHomeRespone.h"
#import "HKUserCategoryListRespone.h"
#import "HKSubCategoryListRespone.h"
#import "HKLuckyBurstRespone.h"
#import "HKLuckyBurstListRespone.h"
#import "HKluckyBurstDetailRespone.h"
#import "HKSearchModels.h"
#import "SearchGoodsRespone.h"
#import "LuckyBurstFriendsRespone.h"
#import "CategoryProductListRespone.h"
@implementation HKShoppingViewModel
+(void)getRecruitInfoSuccess:(void (^)( HKLeShopHomeRespone* responde))success{
    [HK_BaseRequest buildPostRequest:get_getMainList body:@{} success:^(id  _Nullable responseObject) {
        HKLeShopHomeRespone *respone = [HKLeShopHomeRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        HKLeShopHomeRespone *respone = [[HKLeShopHomeRespone alloc]init];;
        success(respone);
    }];
}
+(void)getCategoryListSuccess:(void (^)( HKUserCategoryListRespone* responde))success{
    [HK_BaseRequest buildPostRequest:get_categoryList body:@{} success:^(id  _Nullable responseObject) {
        HKUserCategoryListRespone *respone = [HKUserCategoryListRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        HKUserCategoryListRespone *respone = [[HKUserCategoryListRespone alloc]init];;
        success(respone);
    }];
}
+(void)getSubCategoryList:(NSDictionary*)dict success:(void (^)( HKSubCategoryListRespone* responde))success{
    [HK_BaseRequest buildPostRequest:get_subCategoryList body:dict success:^(id  _Nullable responseObject) {
        HKSubCategoryListRespone *respone = [HKSubCategoryListRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        HKSubCategoryListRespone *respone = [[HKSubCategoryListRespone alloc]init];;
        success(respone);
    }];
}
+(void)getLuckyBurst:(NSDictionary*)dict success:(void (^)( HKLuckyBurstRespone* responde))success{
    [HK_BaseRequest buildPostRequest:get_getLuckyBurst body:dict success:^(id  _Nullable responseObject) {
        HKLuckyBurstRespone *respone = [HKLuckyBurstRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        HKLuckyBurstRespone *respone = [[HKLuckyBurstRespone alloc]init];;
        success(respone);
    }];
}
+(void)getLuckyBurstList:(NSDictionary*)dict success:(void (^)( HKLuckyBurstListRespone* responde))success{
    [HK_BaseRequest buildPostRequest:get_getLuckyBurstList body:dict success:^(id  _Nullable responseObject) {
        HKLuckyBurstListRespone *respone = [HKLuckyBurstListRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        HKLuckyBurstListRespone *respone = [[HKLuckyBurstListRespone alloc]init];;
        success(respone);
    }];
}
+(void)buyLuckyBurst:(NSDictionary*)dict success:(void (^)( HKBaseResponeModel* responde))success{
    [HK_BaseRequest buildPostRequest:get_buyLuckyBurst body:dict success:^(id  _Nullable responseObject) {
        HKBaseResponeModel *respone = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        HKBaseResponeModel *respone = [[HKBaseResponeModel alloc]init];;
        success(respone);
    }];
}
+(void)luckyBurstDetail:(NSDictionary*)dict success:(void (^)( HKluckyBurstDetailRespone* responde))success{
    [HK_BaseRequest buildPostRequest:get_luckyBurstDetail body:dict success:^(id  _Nullable responseObject) {
        HKluckyBurstDetailRespone *respone = [HKluckyBurstDetailRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        HKluckyBurstDetailRespone *respone = [[HKluckyBurstDetailRespone alloc]init];;
        success(respone);
    }];
}
+(void)shopSearchProductHistory:(void (^)( HKLeShopHomeRespone* responde))success{
    [HK_BaseRequest buildPostRequest:get_getMainList body:@{} success:^(id  _Nullable responseObject) {
        HKLeShopHomeRespone *respone = [HKLeShopHomeRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        HKLeShopHomeRespone *respone = [[HKLeShopHomeRespone alloc]init];;
        success(respone);
    }];
}
+(void)shopSearchProductHistory:(NSDictionary*)dict success:(void (^)( SearchGoodsRespone* responde))success{
    [HK_BaseRequest buildPostRequest:get_shopSearchProductHistory body:dict success:^(id  _Nullable responseObject) {
        SearchGoodsRespone *respone = [SearchGoodsRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        SearchGoodsRespone *respone = [[SearchGoodsRespone alloc]init];;
        success(respone);
    }];
    
}

+(void)searchProduct:(NSDictionary*)dict success:(void (^)(NSMutableArray*dataArray))success{
    [HK_BaseRequest buildPostRequest:get_searchProduct body:dict success:^(id  _Nullable responseObject) {
        if ([responseObject[@"data"]isKindOfClass:[NSArray class]]) {
            NSMutableArray*array = [HKSearchModels mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            success(array);
        }else{
            success(nil);
        }
    } failure:^(NSError * _Nullable error) {
        success(nil);
    }];
}
+(void)getLuckyBurstByAdv:(NSDictionary*)dict success:(void (^)( HKBaseResponeModel* responde))success{
    [HK_BaseRequest buildPostRequest:get_getLuckyBurstByAdv body:dict success:^(id  _Nullable responseObject) {
        HKBaseResponeModel *respone = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        HKBaseResponeModel *respone = [[HKBaseResponeModel alloc]init];;
        success(respone);
    }];
}
+(void)getLuckyBurstByFriend:(NSDictionary*)dict success:(void (^)( HKBaseResponeModel* responde))success{
    [HK_BaseRequest buildPostRequest:get_getLuckyBurstByFriend body:dict success:^(id  _Nullable responseObject) {
        HKBaseResponeModel *respone = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        HKBaseResponeModel *respone = [[HKBaseResponeModel alloc]init];;
        success(respone);
    }];
}
+(void)mediaShopCartCountSuccess:(void (^)( HKBaseResponeModel* responde))success{
    [HK_BaseRequest buildPostRequest:get_mediaShopCartCount body:@{@"loginUid":HKUSERLOGINID} success:^(id  _Nullable responseObject) {
        HKBaseResponeModel *respone = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        HKBaseResponeModel *respone = [[HKBaseResponeModel alloc]init];;
        success(respone);
    }];
}
+(void)deleteCartByid:(NSDictionary*)dict success:(void (^)( HKBaseResponeModel* responde))success{
    [HK_BaseRequest buildPostRequest:get_deleteCartByid body:dict success:^(id  _Nullable responseObject) {
        HKBaseResponeModel *respone = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        HKBaseResponeModel *respone = [[HKBaseResponeModel alloc]init];;
        success(respone);
    }];
}
+(void)getLuckyBurstFriends:(NSDictionary*)dict success:(void (^)( LuckyBurstFriendsRespone* responde))success{
    [HK_BaseRequest buildPostRequest:get_getLuckyBurstFriends body:dict success:^(id  _Nullable responseObject) {
        LuckyBurstFriendsRespone *respone = [LuckyBurstFriendsRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        LuckyBurstFriendsRespone *respone = [[LuckyBurstFriendsRespone alloc]init];;
        success(respone);
    }];
}
+(void)getbottomProductList:(NSDictionary*)dict success:(void (^)( CategoryProductListRespone* responde))success{
    [HK_BaseRequest buildPostRequest:get_bottomProductList body:dict success:^(id  _Nullable responseObject) {
        CategoryProductListRespone *respone = [CategoryProductListRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        CategoryProductListRespone *respone = [[CategoryProductListRespone alloc]init];;
        success(respone);
    }];
}
@end
