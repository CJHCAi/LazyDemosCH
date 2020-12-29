//
//  HK_WalletTool.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HK_BaseRequest.h"
#import "HK_WallectListController.h"
#import "HkK_IncomeController.h"
#import "HK_RechargeController.h"
#import "MyWalletLogModel.h"
@interface HK_WalletTool : NSObject

/**
 *  获取用户钱包信息
 */
+(void)getUserWalletInfoWithSuccessBlock:(void(^)(id responseObject))success;

/**
 *  跳转到资产明细界面
 */
+(void)pushWalletListController:(UIViewController *)controller;
/**
 *  跳转到我的收入资产界面
 */
+(void)pushMyIncomeController:(UIViewController *)controller;

/**
 *  跳转充值界面
 */
+(void)pushChargeController:(UIViewController *)controller;
/**
 *  获取今日收益列表
 */
+(void)getUserTodayIncomeListWithPage:(NSInteger)page successBlock:(void(^)(MyWalletLogModel * response))response  fial:(void(^)(NSString *error))error;

/**
 *  获取用户乐币
 */
+(void)getUserCoinsByType:(NSInteger)type andPages:(NSInteger)page successBlock:(void(^)(MyWalletLogModel * response))response  fial:(void(^)(NSString *error))error;




@end
