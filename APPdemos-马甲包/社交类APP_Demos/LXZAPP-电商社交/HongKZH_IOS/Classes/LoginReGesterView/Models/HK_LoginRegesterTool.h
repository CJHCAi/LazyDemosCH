//
//  HK_LoginRegesterTool.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TencentOpenAPI/TencentApiInterface.h"
#import "TencentOpenAPI/TencentOAuth.h"
#import "HK_ReGisterView.h"
#import "HKLoginViewController.h"
#import "HK_BaseRequest.h"
#import "LoginUserDataModel.h"
#import "HK_CodeReceived.h"
#import "HKNickNameController.h"
#import "HK_NetWork.h"
#import "HKTagSetController.h"
#import "HK_UserTagResponse.h"
@interface HK_LoginRegesterTool : NSObject

/**
 *  更新用户个人信息
 */
+(void)updateUserInfoWithDic:(NSMutableDictionary *)dic successBlock:(void(^)(void))success fail:(void(^)(NSString *msg))error;

/**
 *  用户增加自媒体分类
 */
+(void)addCatergoryListForUserWithCaterArray:(NSMutableArray *)caterArr successBlock:(void(^)(void))success error:(void(^)(NSString *error))error;

/**
 *  保存用户标签
 */
+(void)saveUserTagListWithSelectTagArr:(NSMutableArray *)selectArr succeessBlock:(void(^)(void))success andFail:(void(^)(NSString *error))error;

/**
 *  获取用户标签
 */
+(void)getUserSetingTabLabelsSuccess:(void(^)(NSArray *array))array userSelectArr:(void(^)(NSArray *selectArr))selectArr  failed:(void(^)(NSString *msg))meg;

/**
 *  完善用户信息第二步
 */
+(void)completeUserInfoStepWithHeadImgeArr:(NSMutableArray *)imageArr WithUserName:(NSString *)name andCurrentVC:(UIViewController *)controller;
/**
 *  完善用户信息第一步
 */
+(void)completeUserInfoFirstStepWithBirthDay:(NSString *)birthDay WithSex:(NSInteger)sex  andCurrentVc:(UIViewController *)controller;

/**
 *  qq授权时使用
 */
+(void)StartTencentOAuth:(TencentOAuth *)oAuth andDelegete:(id)controllerDelegete;

/**
 *  微信授权成功进行登录
 */
+(void)WeixinOauthSuccessForApi:(NSString *)code withCurrentVc:(UIViewController *)controller;
/**
 *  QQ授权成功进行登录
 */
+(void)tencentOauthSuccessApi:(APIResponse*)response andOpenId:(NSString *)openid withCurrentController:(UIViewController *)controller;

/**
 *  跳转到注册界面
 */
+(void)pushRigeSterControllerWithCurrentVc:(UIViewController *)controller;
/**
 *  账号密码登录
 */

+(void)loadAppWithParamsDic:(NSDictionary *)params andCurrentController:(UIViewController *)controller;
/**
 *  跳转登录界面
 */
+(void)pushLoadControllerWithCurrentVc:(UIViewController *)controller withType:(int)fromType;

/**
 *  跳转到验证码界面
 */
+(void)pushCodeSendMessageVcWithPreCode:(NSString *)presString andPhone:(NSString *)phonString withTypeCode:(codeReceivedType)typeCode onCurrentVc:(UIViewController *)controller;

@end
