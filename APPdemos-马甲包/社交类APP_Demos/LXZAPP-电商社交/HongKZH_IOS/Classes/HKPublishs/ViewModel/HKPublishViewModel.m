//
//  HKPublishViewModel.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/21.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKPublishViewModel.h"
#import "HK_NetWork.h"
#import "HK_UserProductList.h"
@implementation HKPublishViewModel
+(void)uploadPublish:(NSString*)urlStr callback:(HJHttpRequest)callback{
    HKReleaseVideoParam *param = [HKReleaseVideoParam shareInstance];;
    NSString *url = [Host stringByAppendingString:urlStr];
[HK_NetWork uploadFileWithURL:url parameters:[param dataDict] name:@"imgSrc" filePath:param.filePath images:[param imagesData] progress:^(NSProgress *progress) {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showProgress:(float)progress.completedUnitCount/progress.totalUnitCount status:@"上传中"];
     }callback:^(id responseObject, NSError *error) {
         callback(responseObject,error);
    }];
}
+(void)getProductList:(NSDictionary*)dict success:(void (^)( HK_UserProductList* responde))success{
    [HK_BaseRequest buildPostRequest:get_productList body:dict success:^(id  _Nullable responseObject) {
        HK_UserProductList* responde = [HK_UserProductList mj_objectWithKeyValues:responseObject];
        success(responde);
    } failure:^(NSError * _Nullable error) {
        HK_UserProductList* responde = [[HK_UserProductList alloc]init];;
        success(responde);
    }];
}
    @end
