//
//  HK_BuyAfterTool.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/5.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_BuyAfterTool.h"
#import "HK_BaseRequest.h"
@implementation HK_BuyAfterTool

//取消投诉
+(void)cancelUserOderWithOrderNumber:(NSString *)orderNumber handleBlock:(successBlock)successBlock failError:(fail)failBlock {
    NSMutableDictionary * params =[[NSMutableDictionary alloc] init];
    [params setValue:LOGIN_UID forKey:@"loginUid"];
    [params setValue:orderNumber forKey:@"orderNumber"];
    
    [HK_BaseRequest buildPostRequest:get_mediaShopcanceluserOrderComplaint body:params success:^(id  _Nullable responseObject) {
        NSInteger code =[responseObject[@"code"] integerValue];
        if (code) {
            NSString *msg  =responseObject[@"msg"];
            failBlock(msg);
        }else {
            successBlock();
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}

//取消退货退款
+(void)confirmCollectGoodsWithOrderNumber:(NSString *)orderNumber withAfterStatus:(AfterSaleViewStatue)status handleBlock:(successBlock)successBlock failError:(fail)failBlock {
    NSMutableDictionary * params =[[NSMutableDictionary alloc] init];
    [params setValue:LOGIN_UID forKey:@"loginUid"];
    [params setValue:orderNumber forKey:@"orderNumber"];
    NSString *api;
    if (status==AfterSaleViewStatue_Application) {
        
        api = get_mediaShopcanceluserOrderRefund;
    }else {
        
        api = get_mediaShopcanceluserOrderRefundAndGoods;
    }
    [HK_BaseRequest buildPostRequest:api body:params success:^(id  _Nullable responseObject) {
        NSInteger code =[responseObject[@"code"] integerValue];
        if (code) {
            NSString *msg  =responseObject[@"msg"];
            failBlock(msg);
        }else {
            successBlock ();
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
//计算退款截止时间
+(NSString *)calculateRefundWithLimiteTime:(NSString *)limite andApplyTime:(NSString *)apply{
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // 截止时间date格式
    NSDate  *expireDate = [formater dateFromString:limite];
    NSDate  *nowDate = [formater dateFromString:apply];
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
    if (timeInterval<=0) {
        return @"退款终止";
    }
        if (days) {
            return [NSString stringWithFormat:@"%@天%@小时%@分", dayStr,hoursStr, minutesStr];
        }
    return [NSString stringWithFormat:@"%@小时%@分",hoursStr, minutesStr];
}
//填写物流
+(void)pushAddressControllerWithOrderString:(NSString *)orderString withCurrentVC:(UIViewController *)vc{
    HK_addAdress *addVC =[[HK_addAdress alloc] init];
    addVC.orderNumber =orderString;
    [vc.navigationController pushViewController:addVC animated:YES];
    
}
@end
