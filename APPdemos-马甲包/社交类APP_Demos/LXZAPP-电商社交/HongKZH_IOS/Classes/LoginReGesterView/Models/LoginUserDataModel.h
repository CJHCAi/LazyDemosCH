//
//Created by ESJsonFormatForMac on 18/08/21.
//

#import <Foundation/Foundation.h>

#define LOGIN_USER_USERNAME @"login_user_username"
#define LOGIN_USER_PASSWORD @"login_user_password"
#define LOGIN_USER_ITEM @"loign_user_item"
#define LOGIN_UID  HKUSERLOGINID//[LoginUserData sharedInstance].loginUid
@class LoginUserData;

@interface LoginUserData : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *occupation;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *level;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *token;

@property (nonatomic, copy) NSString *loginUid;

@property (nonatomic, copy) NSString *companyName;

@property (nonatomic, assign)NSInteger isEnterpriserecRuited;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *chatId;

@property (nonatomic, copy) NSString * birthday;

@property (nonatomic, strong)UIImage *portait;
//用户乐币数量
@property (nonatomic, assign) double integral;;

@property (nonatomic, copy) NSString * isFirst;

+(instancetype)sharedInstance;

@end

@interface LoginUserDataModel : NSObject

+ (void)clearUserInfo;
+(void)clearLoginUse;
+(BOOL)isNeedLoginRequest;
+ (void)saveLoginUser:(NSDictionary *)result;
+(void)saveCardInfo:(NSDictionary *)result;
+ (void)saveUserInfoUsername:(NSString *)username password:(NSString *)password;
+ (void)saveUserInfoUsername:(NSString *)username;
+ (void)saveUserInfopassword:(NSString *)password;
+ (NSString *)getUsername;
+ (NSString *)getPassword;
+(NSDictionary *)getLoginUserDict;
+(LoginUserData *)getUserInfoItems;

/** 产看是否存在ssionID是否登录过*/
+(BOOL)isHasSessionId;

@end


