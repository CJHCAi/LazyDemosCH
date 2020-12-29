//
//  HKHomeTool.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/9.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKHomeTool.h"
#import "HK_BaseRequest.h"

@implementation HKHomeTool

+(void)getRecomendListWithPage:(NSInteger)page SuccessBlock:(void(^)(HKReconmendBaseResponse *response))response fail:(void(^)(NSString *error))error {
    [HK_BaseRequest buildPostRequest:get_mainHotAdvList body:@{@"pageNumber":@(page)} success:^(id  _Nullable responseObject) {
        HKReconmendBaseResponse * rec =[HKReconmendBaseResponse mj_objectWithKeyValues:responseObject];
        if (rec.code==0) {
            response(rec);
        }else {
            error(rec.msg);
        }
    } failure:^(NSError * _Nullable error) {
        
    }
     ];
}
@end
