//
//  HK_BuyAfterTool.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/5.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKAddressViewController.h"
#import "HKLogisticsViewController.h"
#import "HKOrderFromInfoRespone.h"
#import "HK_addAdress.h"
/** 成功回调*/
typedef void(^successBlock)(void);
/** 失败回调*/
typedef void(^fail)(NSString * msg);

@interface HK_BuyAfterTool : NSObject

@property (nonatomic, copy) successBlock succBlock;

@property (nonatomic, copy) fail failBlock;


/**
 *  取消订单投诉
 */
+(void)cancelUserOderWithOrderNumber:(NSString *)orderNumber handleBlock:(successBlock)successBlock failError:(fail)failBlock;
/**
 *  取消退款 退货
 */
+(void)confirmCollectGoodsWithOrderNumber:(NSString *)orderNumber withAfterStatus:(AfterSaleViewStatue)status handleBlock:(successBlock)successBlock failError:(fail)failBlock;

/**
 * 计算退款限制时间
 */
+(NSString *)calculateRefundWithLimiteTime:(NSString *)limite andApplyTime:(NSString *)apply;

/**
 * 填写物流地址
 */
+(void)pushAddressControllerWithOrderString:(NSString *)orderString withCurrentVC:(UIViewController *)vc;



@end
