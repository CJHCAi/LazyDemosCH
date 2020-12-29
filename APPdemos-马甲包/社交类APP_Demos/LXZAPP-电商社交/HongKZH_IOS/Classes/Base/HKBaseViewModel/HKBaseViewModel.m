//
//  HKBaseViewModel.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewModel.h"
#import "HKInitializationRespone.h"
#import "HKCountryModels.h"
#import "HKShopDataInitRespone.h"
#import "HKChinaModel.h"
#import "getChinaList.h"
#import "HKProvinceModel.h"
#import "HKCityModel.h"
#import "HKUploadRespone.h"
@implementation HKBaseViewModel
+(void)initDataSuccess:(void (^)(BOOL isSave,HKInitializationRespone*respone))succes{
 HKInitializationRespone*model =   [NSKeyedUnarchiver unarchiveObjectWithFile:KinitDataPath];
    if (model== nil) {
        [HK_BaseRequest buildPostRequest:get_baseData body:@{@"loginUid":HKUSERLOGINID,@"version":APP_Version} success:^(id  _Nullable responseObject) {
            HKInitializationRespone*respone = [HKInitializationRespone mj_objectWithKeyValues:responseObject];
            if (respone.responeSuc) {
                 [NSKeyedArchiver archiveRootObject:respone toFile:KinitDataPath];
                succes(YES,respone);
            }else{
                succes(NO,nil);
                
            }
        } failure:^(NSError * _Nullable error) {
            succes(NO,nil);
        }];
    }else{
        succes(YES,model);
    }

}
+(void)initCountryDataSuccess:(void (^)(BOOL isSave,NSMutableArray*dataArray))succes{
    
    NSMutableArray*array  =   [NSKeyedUnarchiver unarchiveObjectWithFile:KCountryListData];
    if (array.count == 0) {
        [HK_BaseRequest buildPostRequest:get_countryStateList body:@{@"parentId":@"0"} success:^(id  _Nullable responseObject) {
            HKBaseResponeModel*respone = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
            if (respone.responeSuc) {
                NSMutableArray*arrays = [HKCountryModels mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                [NSKeyedArchiver archiveRootObject:arrays toFile:KCountryListData];
                succes(YES,arrays);
            }else{
                succes(NO,nil);
                
            }
        } failure:^(NSError * _Nullable error) {
            succes(NO,nil);
        }];
    }else{
        succes(YES,array);
    }
    
}
+(void)initCountryData:(NSMutableArray*)modelArray param:(HKCountryModels*)parm success:(void (^)(BOOL isSave,NSMutableArray*dataArray))succes{
    if (parm.dataArray.count>0) {
        succes(YES,parm.dataArray);
    }else{
        [HK_BaseRequest buildPostRequest:get_countryStateList body:@{@"parentId":parm.code} success:^(id  _Nullable responseObject) {
            HKBaseResponeModel*respone = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
            if (respone.responeSuc) {
                NSMutableArray*arrays = [HKCountryModels mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                parm.dataArray = arrays;
                [NSKeyedArchiver archiveRootObject:modelArray toFile:KCountryListData];
                succes(YES,arrays);
            }else{
                succes(NO,nil);
                
            }
        } failure:^(NSError * _Nullable error) {
            succes(NO,nil);
        }];
    }
}
+(void)getShopDataSuccess:(void (^)(BOOL isSave,HKShopDataInitRespone*respone))succes{
     HKShopDataInitRespone*model =   [NSKeyedUnarchiver unarchiveObjectWithFile:KinitShopDataPath];
    if (model == nil) {
        [HK_BaseRequest buildPostRequest:get_shopData body:@{@"loginUid":HKUSERLOGINID,@"version":APP_Version} success:^(id  _Nullable responseObject) {
            HKShopDataInitRespone*respone = [HKShopDataInitRespone mj_objectWithKeyValues:responseObject];
            if (respone.responeSuc) {
                [NSKeyedArchiver archiveRootObject:respone toFile:KinitShopDataPath];
                succes(YES,respone);
            }else{
                succes(NO,nil);
                
            }
        } failure:^(NSError * _Nullable error) {
            succes(NO,nil);
        }];
    }else{
        if (model.data.areasArray.count == 0) {
            model.data.mediaAreas = model.data.mediaAreas;
        }
        succes(YES,model);
    }
}
+(void)initCityDataSuccess:(void (^)(BOOL isSave,HKChinaModel*respone))succes{
    __block HKChinaModel*chinaM =   [NSKeyedUnarchiver unarchiveObjectWithFile:KCityListData];
    if (chinaM.provinces.count == 0) {
        [HK_BaseRequest buildPostRequest:get_chinaList body:@{@"version":APP_Version} success:^(id  _Nullable responseObject) {
                
                
                //    NSLog(@"processDictionary:%@", dictionary);
                getChinaList *base = [getChinaList mj_objectWithKeyValues:responseObject];
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    if (chinaM.provinces.count == 0) {
                        chinaM = [[HKChinaModel alloc]init];
                        for (getChinaListProvinces*pro in base.data.provinces) {
                            HKProvinceModel*proM = [[HKProvinceModel alloc]init];
                            proM.code = pro.code;
                            proM.name = pro.name;
                            [base.data.cities enumerateObjectsUsingBlock:^(getChinaListCities * _Nonnull city, NSUInteger idx, BOOL * _Nonnull stop) {
                                if (city.provinceId.intValue == proM.code.intValue) {
                                    HKCityModel*cityM = [[HKCityModel alloc]init];
                                    cityM.code = city.code;
                                    cityM.name = city.name;
                                    cityM.provinceId = city.provinceId;
                                    [proM.citys addObject:cityM];
                                    [base.data.areas enumerateObjectsUsingBlock:^(getChinaListAreas *  ares, NSUInteger idx, BOOL * _Nonnull stop) {
                                        if (ares.cityId.intValue == cityM.code.intValue) {
                                            [cityM.areas addObject:ares];
//                                            [base.data.areas removeObject:ares];
                                        }
                                    }];
//                                    [base.data.cities removeObject:city];
                                }
                                
                                
                                
                                
                            }];
                            [chinaM.provinces addObject:proM];
                        }
                        [NSKeyedArchiver archiveRootObject:chinaM toFile:KCityListData];
                        
                    }
                });
                
            
        } failure:^(NSError * _Nullable error) {
            succes(NO,nil);
        }];
    }else{
        succes(YES,chinaM);
    }
    
}
+(void)initUploadSuccess:(void (^)(BOOL isSave,HKUploadRespone*respone))succes{
    HKUploadRespone*model =   [NSKeyedUnarchiver unarchiveObjectWithFile:KReleaseConfig];
    if (model== nil||[model isLoad]) {
        [HK_BaseRequest buildPostRequest:get_releaseConfig body:@{@"loginUid":HKUSERLOGINID} success:^(id  _Nullable responseObject) {
            HKUploadRespone*respone = [HKUploadRespone mj_objectWithKeyValues:responseObject];
            if (respone.responeSuc) {
                [NSKeyedArchiver archiveRootObject:respone toFile:KReleaseConfig];
                succes(YES,respone);
            }else{
                succes(NO,nil);
                
            }
        } failure:^(NSError * _Nullable error) {
            succes(NO,nil);
        }];
    }else{
        succes(YES,model);
    }
    
}
@end
