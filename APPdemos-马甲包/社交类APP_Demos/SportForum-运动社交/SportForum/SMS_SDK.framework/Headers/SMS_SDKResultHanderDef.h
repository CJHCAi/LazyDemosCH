//
//  SMS_SDKResultHanderDef.h
//  SMS_SDKDemo
//
//  Created by 掌淘科技 on 14-7-11.
//  Copyright (c) 2014年 掌淘科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMS_SDKError.h"

/**
 * @brief 返回状态。
 */
enum SMS_ResponseState
{
    SMS_ResponseStateFail = 0,
    SMS_ResponseStateSuccess=1
};

enum SMS_GetVerifyCodeResponseState
{
    SMS_ResponseStateGetVerifyCodeFail = 0,
    SMS_ResponseStateGetVerifyCodeSuccess=1,
    SMS_ResponseStateMaxVerifyCode=2,
    SMS_ResponseStateGetVerifyCodeTooOften=3
};

/**
 * @brief 验证码获取回调
 * @param 1:代表获取成功 0:代表获取失败
 */
typedef void (^GetVerifyCodeBlock)(enum SMS_GetVerifyCodeResponseState state);

/**
 *  @brief 验证码获取回调
 *  @param error 当error为空时表示成功
 */
typedef void (^GetVerificationCodeResultHandler) (SMS_SDKError *error);

/**
 * @brief 验证码验证回调
 * @param 1:代表验证成功 0:代表验证失败
 */
typedef void (^CommitVerifyCodeBlock)(enum SMS_ResponseState state);

/**
 * @brief 国家区号获取回调
 * @param 1:代表获取成功 0:代表获取失败
 * @param 返回的区号数组
 */
typedef void (^GetZoneBlock)(enum SMS_ResponseState state,NSArray* zonesArray);

/**
 * @brief 通讯录好友获取回调
 * @param 1:代表获取成功 0:代表获取失败
 * @param 返回的好友信息数组
 */
typedef void (^GetAppContactFriendsBlock)(enum SMS_ResponseState state,NSArray* friendsArray);

/**
 * @brief 提交用户信息回调
 * @param 1:代表获取成功 0:代表获取失败
 */
typedef void (^SubmitUserInfoBlock) (enum SMS_ResponseState state);

/**
 * @brief 设置最近新好友回调
 * @param 1:代表成功 0:代表失败
 * @param 代表最近新好友条数
 */
typedef void (^ShowNewFriendsCountBlock)(enum SMS_ResponseState state,int latelyFriendsCount);

@interface SMS_SDKResultHanderDef : NSObject

@end
