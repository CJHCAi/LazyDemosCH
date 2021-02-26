//
//  CHDeviceInfoManager.h
//  CHDeviceInfoSDK
//
//  Created by 火虎MacBook on 2021/2/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CHDeviceInfoManager : NSObject
@property (nonatomic,copy) NSString * HostUrl;
@property (nonatomic,copy) NSString *APPID;


+(instancetype)shareInstance;
/**SDK初始化方法*/
-(void)initSDKWithHostUrl:(NSString *)hostUrl  APPID:(NSString *)appID;
/**启动事件上报*/
-(void)startLaunchEvent;
/**注册事件上报*/
-(void)startRegisterEvent;
/**付费事件上报*/
-(void)startPayEventWithMoney:(NSString *)money;


@end

NS_ASSUME_NONNULL_END
