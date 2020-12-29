//
//  HKBaseViewModel.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HK_BaseRequest.h"
typedef enum{
    MYUpperProductOrder_time = 1,//添加时间
    MYUpperProductOrder_SalesVolume = 2,//销量
    MYUpperProductOrder_AAturnover = 3,//交易额
    MYUpperProductOrder_Stock = 4 //库存
}MYUpperProductOrder;
@class HKInitializationRespone,HKCountryModels,HKShopDataInitRespone,HKChinaModel,HKUploadRespone;
@interface HKBaseViewModel : NSObject
+(void)initDataSuccess:(void (^)(BOOL isSave,HKInitializationRespone*respone))succes;
+(void)initCityDataSuccess:(void (^)(BOOL isSave,HKChinaModel*respone))succes;
+(void)initCountryDataSuccess:(void (^)(BOOL isSave,NSMutableArray*dataArray))succes;
+(void)initCountryData:(NSMutableArray*)modelArray param:(HKCountryModels*)parm success:(void (^)(BOOL isSave,NSMutableArray*dataArray))succes;
+(void)getShopDataSuccess:(void (^)(BOOL isSave,HKShopDataInitRespone*respone))succes;
+(void)initUploadSuccess:(void (^)(BOOL isSave,HKUploadRespone*respone))succes;


@end

