//
//  HKLoginViewModel.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/22.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKLoginViewModel.h"
#import "HKLogInUserModel.h"
#import "RCDRCIMDataSource.h"
@implementation HKLoginViewModel
+(void)loginWithPhoneAndPassword:(NSDictionary*)dict success:(void (^)(BOOL isSuc))success{
 [HK_BaseRequest  buildPostRequest:get_phoneLgin body:dict success:^(id  _Nullable responseObject) {
        HKLogInUserModel *model = [HKLogInUserModel mj_objectWithKeyValues:responseObject];
        [kNSUserDefaults setObject:model.data.token  forKey:kToken];
        [kNSUserDefaults setObject:model.data.loginUid  forKey:kloginUid];
        [kNSUserDefaults setObject:model.data.name  forKey:kName];
        [kNSUserDefaults setObject:model.data.uid  forKey:kUid];
        [kNSUserDefaults synchronize];
        success(YES);
    } failure:^(NSError * _Nullable error) {
        success(NO);
    }];
}
+(void)loginWithSendMsg:(NSDictionary*)dict success:(void (^)(BOOL isSuc))success{
   [HK_BaseRequest  buildPostRequest:get_sendloginmessage body:dict success:^(id  _Nullable responseObject) {
        success(YES);
    } failure:^(NSError * _Nullable error) {
        success(NO);
    }];

}
+(void)addRCIM
{
    
    //    HK_UserModelData *item = (HK_UserModelData *)[ViewModelLocator sharedModelLocator].userModelBase.userModel;
    //    avhGJYXMtIom5QYPjrF7xj8jbPoHLaMRpy/+75SgXBWJVqA7mhP0EsiEcdjR7BaeQH1vESwRr6Zc2ld3QuSMkg==
    LoginUserData*userData = [LoginUserDataModel getUserInfoItems];
    [[RCIM sharedRCIM] connectWithToken:userData.token                                success:^(NSString *userId) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[RCIM sharedRCIM] setUserInfoDataSource:RCDDataSource];
            [[RCIM sharedRCIM] setGroupInfoDataSource:RCDDataSource];
            RCUserInfo*userInfo = [[RCUserInfo alloc]initWithUserId:userId name:userData.name portrait:userData.headImg];
            [RCIM sharedRCIM].currentUserInfo = userInfo;
        });
        DLog(@"登陆成功。当前登录的用户ID：%@", userId);
    } error:^(RCConnectErrorCode status) {
        DLog(@"登陆的错误码为:%ld", (long)status);
    } tokenIncorrect:^{
        //token过期或者不正确。
        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
        DLog(@"token错误");
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RCIMFrendNotification" object:nil];
}
@end
