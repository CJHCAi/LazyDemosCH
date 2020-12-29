//
//  HKCounponTool.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCounponTool.h"

@implementation HKCounponTool

+(void)getMyVipListWithState:(NSInteger)state page:(NSInteger )page successBlock:(void(^)(HKBVipCopunResponse * response))success fail:(void(^)(NSString *error))error {
    [HK_BaseRequest buildPostRequest:get_usermyQualificationCoupon body:@{kloginUid:HKUSERLOGINID,@"pageNumber":@(page),@"state":[NSString stringWithFormat:@"%zd",state]} success:^(id  _Nullable responseObject) {
       HKBVipCopunResponse *res =[HKBVipCopunResponse mj_objectWithKeyValues:responseObject];
        if (res.code==0) {
            success (res);
        }else {
            error(res.msg);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];  
}
+(void)deleteUserCounponWithCounponId:(NSString *)couponId  successBlock:(void(^)(void))success fail:(void(^)(NSString *error))error {
    [HK_BaseRequest buildPostRequest:get_userdeleteCoupon body:@{kloginUid:HKUSERLOGINID,@"couponId":couponId} success:^(id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] ==0) {
            success ();
        }else {
            error ([responseObject objectForKey:@"msg"]);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
+(void)getCounponListWithState:(NSInteger )state page:(NSInteger )page successBlock:(void(^)(HKCouponResponse * response))success fail:(void(^)(NSString *error))error {
    [HK_BaseRequest buildPostRequest:get_usermyCoupon body:@{kloginUid:HKUSERLOGINID,@"pageNumber":@(page),@"state":[NSString stringWithFormat:@"%zd",state]} success:^(id  _Nullable responseObject) {
        HKCouponResponse *res =[HKCouponResponse mj_objectWithKeyValues:responseObject];
        if (res.code==0) {
            success (res);
        }else {
            error(res.msg);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];

}
+(void)getCouponDetailWithCounponId:(NSString *)couponId  successBlock:(void(^)(HKMyCopunDetailResponse *response))success fail:(void(^)(NSString *error))error {
    [HK_BaseRequest buildPostRequest:get_shopGgetCouponByCouponId body:@{kloginUid:HKUSERLOGINID,@"couponId":couponId} success:^(id  _Nullable responseObject) {
        HKMyCopunDetailResponse *res =[HKMyCopunDetailResponse mj_objectWithKeyValues:responseObject];
        if (res.code==0) {
            success (res);
        }else {
            error(res.msg);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}

+(void)getCollageListWithsortId:(NSString *)sortId andsortValue:(NSString *)sortValue andPageNumber:(NSInteger)page  successBlock:(void(^)(HKCollagedResponse *response))success fail:(void(^)(NSString *error))error {
    NSMutableDictionary *dic =[[NSMutableDictionary alloc] init];
    if (sortId.length) {
        [dic setValue:sortId forKey:@"sortId"];
    }
    if (sortValue.length) {
        [dic setValue:sortValue forKey:@"sortValue"];
    }
    [dic setValue:@(page) forKey:@"pageNumber"
     ];
    [HK_BaseRequest buildPostRequest:get_shopGetCollageList body:dic success:^(id  _Nullable responseObject) {
       HKCollagedResponse *res =[HKCollagedResponse mj_objectWithKeyValues:responseObject];
        if (res.code==0) {
            success (res);
        }else {
            error(res.msg);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
 
}
+(void)getCollageDetailCounponId:(NSString *)couponId  successBlock:(void(^)(HKCollageResPonse *response))success fail:(void(^)(NSString *error))error {
    [HK_BaseRequest buildPostRequest:shop_getCollageByCouponId body:@{@"collageCouponId":couponId} success:^(id  _Nullable responseObject) {
       HKCollageResPonse *res =[HKCollageResPonse mj_objectWithKeyValues:responseObject];
        if (res.code==0) {
            success (res);
        }else {
            error(res.msg);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}

+(void)buyCollageOrderWithCollageCounId:(NSString *)collageId successBlock:(void(^)(NSString *response))success fail:(void(^)(NSString *error))error {
    [HK_BaseRequest buildPostRequest:get_shopBuyCollageByCouponId body:@{kloginUid:HKUSERLOGINID,@"collageCouponId":collageId} success:^(id  _Nullable responseObject) {
        NSInteger code =[[responseObject objectForKey:@"code"] integerValue];
        if (code==0) {
            NSString * msg =responseObject[@"data"][@"collageOrderId"];
            success(msg);
        }else {
            NSString * msg=responseObject[@"msg"];
            if (msg.length) {
                error(msg);
            }else {
                error(@"购买失败");
            }
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
+(void)buyCollageByOrderId:(NSString *)orderId successBlock:(void(^)(void))success fail:(void(^)(NSString *error))error {
    [HK_BaseRequest buildPostRequest:get_shopBuyCollageByOrderId body:@{kloginUid:HKUSERLOGINID,@"orderNumber":orderId} success:^(id  _Nullable responseObject) {
        NSInteger code =[[responseObject objectForKey:@"code"] integerValue];
        if (code==0) {
            success();
        }else {
            NSString *msg =[responseObject objectForKey:@"msg"];
            if (msg.length) {
                error(msg);
            }else {
                error(@"拼团失败");
            }
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}

+(void)buyNewUserVipCuponWithVipCouponId:(NSString *)vipCouponId successBlock:(void(^)(NSString *response))success fail:(void(^)(NSString *error))error {
    [HK_BaseRequest buildPostRequest:get_shopBuyNewUserVipCoupon body:@{kloginUid:HKUSERLOGINID,@"vipCouponId":vipCouponId} success:^(id  _Nullable responseObject) {
        NSInteger code =[[responseObject objectForKey:@"code"] integerValue];
        if (code==0) {
            success(@"购买成功");
        }else {
            NSString *msg =[responseObject objectForKey:@"msg"];
            if (msg.length) {
                error(msg);
            }else {
                error(@"拼团失败");
            }
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
+(void)getDisCutCuponListWithPage:(NSInteger)page  successBlock:(void(^)(HKDisCutResponse *response))success fail:(void(^)(NSString *error))error {
    [HK_BaseRequest buildPostRequest:get_discountsList body:@{@"pageNumber":@(page)} success:^(id  _Nullable responseObject) {
        HKDisCutResponse *response =[HKDisCutResponse mj_objectWithKeyValues:responseObject];
        if (response.code==0) {
            success(response);
        }else {
            error(response.msg);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
+(void)getCollageOrderInfo:(NSString *)orderId  successBlock:(void(^)(HKCollageOrderResponse *response))success fail:(void(^)(NSString *error))error {
    [HK_BaseRequest buildPostRequest:get_shopGetCollageByOrderNumber body:@{@"orderNumber":orderId} success:^(id  _Nullable responseObject) {
        HKCollageOrderResponse *response =[HKCollageOrderResponse mj_objectWithKeyValues:responseObject];
        if (response.code==0) {
            success(response);
        }else {
            error(response.msg);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
+(NSString *)getConponLastStringWithEndString:(NSString *)end {
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // 截止时间date格式
    NSDate  *expireDate = [formater dateFromString:end];
    
    NSDate  *nowDate = [NSDate date];
    // 当前时间字符串格式
    NSString *nowDateStr = [formater stringFromDate:nowDate];
    // 当前时间date格式
    nowDate = [formater dateFromString:nowDateStr];
    NSTimeInterval timeInterval =[expireDate timeIntervalSinceDate:nowDate];
    int days = (int)(timeInterval/(3600*24));
    int hours = (int)((timeInterval-days*24*3600)/3600);
    int minutes = (int)(timeInterval-days*24*3600-hours*3600)/60;
    int seconds = timeInterval-days*24*3600-hours*3600-minutes*60;
    
    NSString *dayStr;NSString *hoursStr;NSString *minutesStr;NSString *secondsStr;
    //天
    dayStr = [NSString stringWithFormat:@"%d",days];
    //小时
    hoursStr = [NSString stringWithFormat:@"%d",hours];
    if (hours<10) {
        hoursStr =[NSString stringWithFormat:@"0%d",hours];
    }
    //分钟
    if(minutes<10)
        minutesStr = [NSString stringWithFormat:@"0%d",minutes];
    else
        minutesStr = [NSString stringWithFormat:@"%d",minutes];
    //秒
    if(seconds < 10)
        secondsStr = [NSString stringWithFormat:@"0%d", seconds];
    else
        secondsStr = [NSString stringWithFormat:@"%d",seconds];
    if (hours<=0&&minutes<=0&&seconds<=0) {
        return @"优惠券已过期";
    }
    if (days>0) {
        return [NSString stringWithFormat:@"距离结束: %@:%@:%@:%@",dayStr,hoursStr, minutesStr,secondsStr];
    }else {
          return [NSString stringWithFormat:@"距离结束: %@:%@:%@",hoursStr , minutesStr,secondsStr];
    }
}
+(HKShareBaseModel *)getShareModelFromResponse:(id)response controller:(UIViewController *)vc{
    HKShareBaseModel * mdoel =[[HKShareBaseModel alloc] init];
    mdoel.subVc = vc;
    HKMyGoodsModel * goodsModel =[[HKMyGoodsModel alloc] init];
    mdoel.shareType =SHARE_Type_GOODS;
    if ([response isKindOfClass:[HKMyCopunDetailResponse class]]) {
        HKMyCopunDetailResponse * goods =(HKMyCopunDetailResponse *)response;
        goodsModel.title =goods.data.title;
        goodsModel.createDate = goods.data.beginTime;
        goodsModel.imgSrc = goods.data.imgSrc;
        goodsModel.isFormSelf = NO;
        goodsModel.productId = goods.data.productId;
    }else if([response isKindOfClass:[HKCollageResPonse class]]) {
        HKCollageResPonse * goods =(HKCollageResPonse *)response;
        goodsModel.title =goods.data.title;
        goodsModel.createDate = goods.data.beginTime;
        goodsModel.imgSrc = goods.data.imgSrc;
        goodsModel.isFormSelf = NO;
        goodsModel.productId = goods.data.productId;
    }else if ([response isKindOfClass:[HKBVipCopunResponse class]]) {
        HKCollageResPonse * goods =(HKCollageResPonse *)response;
        goodsModel.title =goods.data.title;
        goodsModel.createDate = goods.data.beginTime;
        goodsModel.imgSrc = goods.data.imgSrc;
        goodsModel.isFormSelf = NO;
        goodsModel.productId = goods.data.productId;
    }
    mdoel.goodsModel = goodsModel;
    
    return mdoel;
}
@end
