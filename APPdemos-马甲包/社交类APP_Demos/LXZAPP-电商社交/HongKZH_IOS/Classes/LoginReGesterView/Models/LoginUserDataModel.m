//
//Created by ESJsonFormatForMac on 18/08/21.
//

#import "LoginUserDataModel.h"

#define LOGIN_USER_USERNAME @"login_user_username"
#define LOGIN_USER_PASSWORD @"login_user_password"
#define LOGIN_USER_ITEM @"loign_user_item"
@implementation LoginUserData
+ (instancetype)sharedInstance
{
    static LoginUserData *dataMng;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        dataMng = [[LoginUserData alloc] init];
       
    });
    return dataMng;
}

@end

@implementation LoginUserDataModel

+ (void)clearUserInfo
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:LOGIN_USER_PASSWORD];
    [userDefaults removeObjectForKey:LOGIN_USER_USERNAME];
    [self clearLoginUse];
    
    [userDefaults synchronize];
}
+(void)clearLoginUse
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:LOGIN_USER_ITEM];
    [userDefaults synchronize];

     LoginUserData*items = [LoginUserData sharedInstance];
     items.headImg = nil;
     items.name = nil;
     items.loginUid =nil;
    //移除cookie
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    if (storage.cookies.count) {
        for (cookie in [storage cookies])
        {
            [storage deleteCookie:cookie];
        }
    }
    //缓存web清除
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    NSUserDefaults * userD =[NSUserDefaults standardUserDefaults];
    [userD removeObjectForKey:@"loginId"];
    
}
+ (void)saveUserInfoUsername:(NSString *)username password:(NSString *)password
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:username forKey:LOGIN_USER_USERNAME];
    [userDefaults setObject:password forKey:LOGIN_USER_PASSWORD];
    [userDefaults synchronize];
    
}
+ (void)saveLoginUser:(NSDictionary *)result
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //如果当前key下有数据先清楚掉
    NSString * value =[userDefaults objectForKey:LOGIN_USER_ITEM];
    if ([AppUtils isNotEmpty:value]) {
        [userDefaults removeObjectForKey:LOGIN_USER_ITEM];
    }
    [userDefaults setObject:[AppUtils toJSONString:result] forKey:LOGIN_USER_ITEM];
    [userDefaults synchronize];
    [self getLoginUser:result];
}

+(LoginUserData *)getLoginUser:(NSDictionary *)result

{
    //给单例模型赋值数据
    LoginUserData * userData =[LoginUserData sharedInstance];
    NSDictionary * dic = result[@"data"];
    LoginUserData * model = [LoginUserData mj_objectWithKeyValues:dic];
    userData.ID =model.ID;
    userData.uid =model.uid;
    userData.occupation =model.occupation;
    userData.sex = model.sex;
    userData.type = model.type;
    userData.level = model.level;
    userData.address =model.address;
    userData.token = model.token;
    userData.loginUid =model.loginUid;
    userData.companyName =model.companyName;
    userData.isEnterpriserecRuited = model.isEnterpriserecRuited;
    userData.headImg =model.headImg;
    userData.name = model.name;
    userData.birthday =model.birthday;
    userData.chatId =model.chatId;
//    userData.isFirst =model.isFirst;
    if (userData.isFirst.intValue) {
#pragma mark 注册成功发送一个通知
        [[NSNotificationCenter defaultCenter] postNotificationName:RegeistNewPerson object:nil];
    }
    return userData;
}
/** 是否登录*/
+(BOOL)isHasSessionId {
    
   // LoginUserData * items = [LoginUserDataModel  getUserInfoItems];
    LoginUserData * items =[LoginUserData sharedInstance];
    if ([AppUtils isNotEmpty:items.loginUid]) {
        return  YES;
    }
    return NO;
}

+ (void)saveUserInfoUsername:(NSString *)username
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:username forKey:LOGIN_USER_USERNAME];
    [userDefaults synchronize];
}
+ (void)saveUserInfopassword:(NSString *)password
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:password forKey:LOGIN_USER_PASSWORD];
    [userDefaults synchronize];
}
+ (NSString *)getUsername
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:LOGIN_USER_USERNAME];
}

+ (NSString *)getPassword
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:LOGIN_USER_PASSWORD];
}
+(NSDictionary *)getLoginUserDict{
    
    NSString *loginString = [[NSUserDefaults standardUserDefaults] stringForKey:LOGIN_USER_ITEM];
    return [AppUtils parseJSON:loginString];
    
}
+(LoginUserData *)getUserInfoItems {
    
    NSString *loginString = [[NSUserDefaults standardUserDefaults] stringForKey:LOGIN_USER_ITEM];
    NSDictionary * dic =[AppUtils parseJSON:loginString];
    
    return  [self getLoginUser:dic];
    
}
@end







