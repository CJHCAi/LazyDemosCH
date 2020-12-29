//
//  HK_orderTool.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/31.
//  Copyright © 2018年 hkzh. All rights reserved.
//
//订单业务处理类
#import <Foundation/Foundation.h>
#import "HK_orderShopHeaderView.h"
//退款 售后
#import "HK_playRefundController.h"
//投诉
#import "HK_orderComplainVc.h"
//物流
#import "HK_transFerController.h"
#import "HKLogisticsViewController.h"

#import "HKOrderFromInfoRespone.h"
//收取信息
#import "HK_InfoTopCell.h"
//支付信息
#import "HK_orderInfoCell.h"
//地址信息
#import "HK_orderAddressCell.h"
//商品信息
#import "HK_MyOrderCell.h"
//支付视图
//#import "HK_PaymentActionSheet.h"
//充值视图
//#import "HK_PaymentActionSheetTwo.h"
//编辑收货地址
#import "HK_AddressInfoView.h"

//充值
#import "HK_RechargeController.h"

/** 成功回调*/
typedef void(^successBlock)(void);
/** 失败回调*/
typedef void(^fail)(NSString * msg);

@interface HK_orderTool : NSObject 

@property (nonatomic, copy) successBlock succBlock;

@property (nonatomic, copy) fail failBlock;

/**
 *  进入充值界面
 */
+(void)pushReChargeController:(UIViewController *)controller;
/**
 *  弹出支付界面 并支付
 */
+(void)showPayInfoViews:(UIViewController *)CurrentVc withOrderInfo:(HK_orderInfo *)mdoel;

/**
 *  充值..
 */
+(void)showSuPllyInfoView:(UIViewController *)CurrentVc withOrderInfo:(HK_orderInfo *)mdoel;

/**
 *  取消订单
 */
+(void)cancelUserOderWithOrderNumber:(NSString *)orderNumber handleBlock:(successBlock)successBlock failError:(fail)failBlock;
/**
 * 确认订单
 */
+(void)confirmCollectGoodsWithOrderNumber:(NSString *)orderNumber handleBlock:(successBlock)successBlock failError:(fail)failBlock;

/**
 * 删除订单
 */
+(void)deleteOrdersWithOrderNumber:(NSString *)orderNumber handleBlock:(successBlock)successBlock failError:(fail)failBlock;
/**
 *  根据订单状态返回指定组数
 */
+(NSInteger)sectionCountWithOrderStates:(NSString *)state;

/**
 * 返回每一组的footer高度
 */
+(CGFloat)sectionFooterHightWithOrderStates:(NSString *)state andSection:(NSInteger)section;

/**
 * 返回每一组的组头高度 只有商品详情cell有
 */
+(CGFloat)sectionHeaderHightWithOrderStates:(NSString *)state andSection:(NSInteger)section;

/**
 * 返回组头视图 只有商品cell有
 */
+(UIView *)sectionHeaderViewWithOrderStates:(HK_orderInfo *)model andSection:(NSInteger)section;
/**
 * 返回每组的行数
 */
+(NSInteger)rowcountForSectionWithOrderState:(HK_orderInfo *)model andSection:(NSInteger)section;
/**
 * 返回每行的高度
 */
+(CGFloat)rowHightWithOrderState:(NSString *)state andSection:(NSInteger)section;

/**
 * 返回Cell
 */
+(UITableViewCell *)configueTableView:(UITableView *)tableView WithOrderStates:(HK_orderInfo *)model andIndexPath:(NSIndexPath *)indexPath andEditDelegete:(id)editUserAddressDelegete;

/**
 * 进入投诉页面
 */
+(void)pushrderComplainVc:(NSString *)orderNumber andCurrentVc:(UIViewController *)controller withType:(int)type;

/**
 * 进入物流界面
 */
+(void)pushOrderLogisticsVc:(HK_orderInfo *)model  andCurrentVc:(UIViewController *)controller;

/**
 * 进入售后退款申请界面
 */
+(void)pushOrderReFundVc:(NSString *)orderNumber orderStatus:(UserOrderStatus)status orderType:(NSString *)types  andCurrentVc:(UIViewController *)controller;
/**
 *  根据时间差计算倒计时时间字符串
 */
+(NSString *)getDataStringFromTimeCount:(NSTimeInterval)timeInterval;
/**
 *  根据当前时间和截止时间计算 时间差
 */
+(NSTimeInterval)AgetCountTimeWithString:(NSString *)limitTime andNowTime:(NSString *)currentTime;

/**
 *  编辑收货地址
 */
+(void)pushEditAdressContorller:(UIViewController *)controller withModel:(HK_orderInfo *)orderModel andTableView:(UITableView *)tableView;

+(void)payOrdersWithNumber:(NSString *)ordersNumber  andCurrentVc:(UIViewController *)vc ;
@end
