//
//  HKEditGoodsViewModel.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKEditGoodsViewModel.h"
#import "HK_NetWork.h"
#import "HKDateTool.h"
@implementation HKEditGoodsViewModel
+(void)loadMyGoodsinfo:(NSDictionary*)dict success:(void (^)(MyGoodsRespone* respone))success{
    [HK_BaseRequest buildPostRequest:get_getMediaProductById body:dict success:^(id  _Nullable responseObject) {
        MyGoodsRespone*respone = [MyGoodsRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        MyGoodsRespone*respone = [[MyGoodsRespone alloc]init];
        respone.code = 1;
        success(respone);
    }];
}
+(void)freightListSuccess:(void (^)(HKFreightListRespone* respone))success{
    [HK_BaseRequest buildPostRequest:get_freightList body:@{kloginUid:HKUSERLOGINID} success:^(id  _Nullable responseObject) {
        HKFreightListRespone*respone = [HKFreightListRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        HKFreightListRespone*respone = [[HKFreightListRespone alloc]init];
        success(respone);
    }];
    
}
+(void)deleteareafreighte:(NSDictionary*)dict success:(void (^)(HKBaseResponeModel* respone))success{
    [HK_BaseRequest buildPostRequest:get_deleteareafreight body:dict success:^(id  _Nullable responseObject) {
        HKBaseResponeModel*respone = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        HKBaseResponeModel*respone = [[HKBaseResponeModel alloc]init];
        success(respone);
    }];
}
+(void)saveMyGoodsinfo:(MyGoodsInfo*)goodsInfo success:(void (^)(BOOL isSuc))success{
    NSString*url;
    if(goodsInfo.images.count>0){
        url = get_updateProductByImg;
    }
    NSMutableArray *array = [NSMutableArray array];
    for (ImagesModel*imageM in goodsInfo.addImage) {
        if (imageM.image != nil) {
           [array addObject:imageM.image];
        }
        
    }
    if (goodsInfo.deleteImage.count > 0) {
        NSMutableString*str = [NSMutableString string];
        for (ImagesModel*imageM in goodsInfo.deleteImage) {
            [str appendString:imageM.imgId];
            [str appendString:@","];
        
        }
        [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];
        NSDictionary *dict = @{@"loginUid":HKUSERLOGINID,@"imgId":str};
        [HK_BaseRequest buildPostRequest:get_deleteProductByImgId body:dict success:^(id  _Nullable responseObject) {
            
        } failure:^(NSError * _Nullable error) {
            
        }];
    }
    if (goodsInfo.deleteSku.count > 0) {
        NSMutableString*str = [NSMutableString string];
        for (SkusModel*skuM in goodsInfo.deleteSku) {
            [str appendString:skuM.skuId];
            [str appendString:@","];
        }
        [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];
        NSDictionary *dict = @{@"loginUid":HKUSERLOGINID,@"skuId":str};
        [HK_BaseRequest buildPostRequest:get_deleteSku body:dict success:^(id  _Nullable responseObject) {
            
        } failure:^(NSError * _Nullable error) {
            
        }];
    }
    NSDictionary*dict = [goodsInfo getPostParameter];
    
    [HK_NetWork uploadEditImageURL:url
                    parameters:dict
                        images:array
                          name:@"imgSrc"
                      fileName:[HKDateTool getCurrentIMServerTime13]
                      mimeType:@"jpeg"
                specifications:goodsInfo.skus
                      progress:^(NSProgress *progress) {
                          DLog(@"正在上传图片...%lli",progress.completedUnitCount);
                      } callback:^(id responseObject, NSError *error) {
                          DLog(@"图片上传完成%@",responseObject);
                          if (!error) {
                              success(YES);
                          }else{
                              success(NO);
                          }
                      }];;
}
+(void)saveAddMyGoodsinfo:(MyGoodsInfo*)goodsInfo success:(void (^)(BOOL isSuc))success{
    NSString*url = get_saveProduct;
    if(goodsInfo.images.count>0){
        url = get_saveProduct;
    }
    NSMutableArray *array = [NSMutableArray array];
    for (ImagesModel*imageM in goodsInfo.addImage) {
        if (imageM.image != nil) {
            [array addObject:imageM.image];
        }
        
    }
    NSDictionary*dict = [goodsInfo getPostParameter];
    
    [HK_NetWork uploadEditImageURL:url
                        parameters:dict
                            images:array
                              name:@"imgSrc"
                          fileName:[HKDateTool getCurrentIMServerTime13]
                          mimeType:@"jpeg"
                    specifications:goodsInfo.skus
                          progress:^(NSProgress *progress) {
                              DLog(@"正在上传图片...%lli",progress.completedUnitCount);
                          } callback:^(id responseObject, NSError *error) {
                              DLog(@"图片上传完成%@",responseObject);
                              if (!error) {
                                  success(YES);
                              }else{
                                  success(NO);
                              }
                          }];;
}
+(void)deleteGoodsImage:(NSDictionary*)dict success:(void (^)(BOOL isSuc))success{
    [HK_BaseRequest buildPostRequest:get_deleteProductByImgId body:dict success:^(id  _Nullable responseObject) {
        success(YES);
    } failure:^(NSError * _Nullable error) {
        
        success(NO);
    }];
}
+(void)deleteProduct:(MyGoodsInfo*)goodsInfo success:(void (^)(BOOL isSuc))success{
    NSDictionary *dic = @{@"loginUid":HKUSERLOGINID,@"productId":goodsInfo.productId};
    [HK_BaseRequest buildPostRequest:get_deleteProduct body:dic success:^(id  _Nullable responseObject) {
        if ([responseObject[@"code"] intValue] == 0) {
            success(YES);
        }else{
            success(NO);
        }
        
    } failure:^(NSError * _Nullable error) {
        success(NO);
    }];
}
+(void)savefreight:(HKFreightListData*)freightListData success:(void (^)(BOOL isSuc))success{
    [freightListData getParameterSuccess:^(NSDictionary *parameter, NSMutableArray *uplodaArray) {
        [HK_NetWork updataFileWithURL:get_savefreight formDataArray:uplodaArray parameters:parameter progress:^(NSProgress *progress) {
            
        } callback:^(id responseObject, NSError *error) {
            if (!error) {
                HKBaseResponeModel*respone = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
                if (respone.responeSuc) {
                    success(YES);
                }else{
                  success(NO);
                }
            }else{
                success(NO);
            }
        }];
    }];
}
@end
