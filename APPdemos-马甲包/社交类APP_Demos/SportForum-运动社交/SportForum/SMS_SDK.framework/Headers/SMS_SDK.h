//
//  SMS_SDK.h
//  SMS_SDKDemo
//
//  Created by 刘 靖煌 on 14-8-28.
//  Copyright (c) 2014年 掌淘科技. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SMS_SDKResultHanderDef.h"
#import "SMS_UserInfo.h"
#import <MessageUI/MessageUI.h>

/**
 * @brief 核心类（Core class）v1.0.9
 */
@interface SMS_SDK : NSObject <MFMessageComposeViewControllerDelegate>

/**
 *  初始化应用，此方法在应用启动时在主线程中调用。(This method is called in the main thread in application:didFinishLaunchingWithOptions: method)
 *
 *  @param appKey    在Mob官网(http://mob.com/ )中注册的应用Key。(The appKey of mob Application. Log in to http://mob.com/ to register to be a Mob developer and create a application if you don't have one)
 *  @param appSecret 在Mob官网(http://mob.com/ )中注册的应用秘钥。(The appSecret of mob Application. Log in to http://mob.com/ to register to be a Mob developer and create a application if you don't have one)
 */
+(void)registerApp:(NSString*)appKey withSecret:(NSString*)appSecret;

#pragma mark - 获取appKey、appSecret、addressBook
/**
 * @brief 获取appKey(Get the appKey)
 */
+(NSString*)appKey;

/**
 * @brief 获取appSecret(Get the appSecret)
 */
+(NSString*)appSecret;

/**
 * @brief 获取通讯录数据(Get the addressBook list data)
 * @return 通讯录数据数组，数据元素类型是SMS_AddressBook(The array of addressBook list data, the type of array's element is SMS_AddressBook)
 */
+(NSMutableArray*)addressBook;

#pragma mark - 获取支持区号、获取验证码和提交验证码 (get the zone、verification code and commit verifacation code)
/**
 * @brief 获取区号(Get the Area code of the country)
 * @param 请求结果回调(Results of the request)
 */
+(void)getZone:(GetZoneBlock)result;

/**
 *  @brief 获取验证码(Get verification code by SMS)
 *
 *  @from  v1.0.7
 *  @param phoneNumber 电话号码(The phone number)
 *  @param zone        区域号，不要加"+"号(Area code)
 *  @param result      请求结果回调(Results of the request)
 */
+ (void)getVerificationCodeBySMSWithPhone:(NSString *)phoneNumber
                                     zone:(NSString *)zone
                                   result:(GetVerificationCodeResultHandler)result;

/**
 *  @brief 获取验证码(Get verification code by SMS)
 *
 *  @from  v1.0.9
 *  @param phoneNumber       电话号码(The phone number)
 *  @param zone              区域号，不要加"+"号(Area code)
 *  @param customIdentifier  自定义短信模板标识 该标识需从官网http://wiki.mob.com/?p=2803上申请，审核通过后获得。(Custom model of SMS.  The identifier can get it  from http://wiki.mob.com/?p=2803  when the application had approved)
 *  @param result            请求结果回调(Results of the request)
 */
+ (void)getVerificationCodeBySMSWithPhone:(NSString *)phoneNumber
                                     zone:(NSString *)zone
                         customIdentifier:(NSString *)customIdentifier
                                   result:(GetVerificationCodeResultHandler)result;

/**
 *  @brief 通过语音电话获取语音验证码（Get verification code via voice call）
 *
 *  @param phone  电话号码(The phone number)
 *  @param zone   区域号，不要加"+"号(Area code)
 *  @param result 请求结果回调(Results of the request)
 */
+ (void)getVerificationCodeByVoiceCallWithPhone:(NSString *)phoneNumber
                                           zone:(NSString *)zone
                                         result:(GetVerificationCodeResultHandler)result;

/**
 * @brief 提交验证码(Commit the verification code)
 * @param 验证码(Verification code)
 * @param 请求结果回调(Results of the request)
 */
+(void)commitVerifyCode:(NSString *)code
                 result:(CommitVerifyCodeBlock)result;

#pragma mark - 是否启用通讯录好友功能、提交用户资料、请求通讯好友信息
/**
 * @brief 是否允许访问通讯录好友(is Allowed to access to address book)
 * @param YES 代表启用 NO 代表不启用 默认为启用(YES,by default,means allow to access to address book)
 */
+(void)enableAppContactFriends:(BOOL)state;

/**
 * @brief 提交用户资料(Submit the user information data)
 * @param 用户信息(User information)
 * @param 请求结果回调(Results of the request)
 */
+(void)submitUserInfo:(SMS_UserInfo*)user
               result:(SubmitUserInfoBlock)result;

/**
 * @brief 向服务端请求获取通讯录好友信息(Get the data of address book which save in the server)
 * @param 调用参数 默认值为1(Get the chosen friend data of address book,the default value is 1)
 * @param 请求结果回调(Results of the request)
 */
+(void)getAppContactFriends:(int)choose
                     result:(GetAppContactFriendsBlock)result;

#pragma mark - 设置最新好友条数、显示最新好友条数
/**
 * @brief 设置新增好友条数(The new added friends)
 * @param 好友条数(The number of friends)
 */
+(void)setLatelyFriendsCount:(int)count;

/**
 * @brief 显示新增好友条数回调(Display recently new friends number callback)
 * @param 结果回调(Results of the request )
 */
+(void)showFriendsBadge:(ShowNewFriendsCountBlock)result;

#pragma mark - 发送短信
/**
 * @brief 发送短信(Send text messages)
 * @param 号码(the phone number)
 * @param 短信内容(the content of the message)
 */
+(void)sendSMS:(NSString*)phoneNumber AndMessage:(NSString*)msg;

#pragma mark - 不再建议使用（deprecated）
/**
 * @brief 获取验证码(Get verification code by SMS)
 * @deprecated 可以使用 +(void)getVerificationCodeBySMSWithPhone:zone:result:替代
   (Deprecated in SMS_SDK v1.0.7  Use +(void)getVerificationCodeBySMSWithPhone:zone:result: instead.)
 *
 * @param 电话号码(The phone number)
 * @param 区域号，不要加"+"号(Area code)
 * @param 请求结果回调(Results of the request)
 */
+(void)getVerifyCodeByPhoneNumber:(NSString*) phone
                          AndZone:(NSString*) zone
                           result:(GetVerifyCodeBlock)result __deprecated;


@end
