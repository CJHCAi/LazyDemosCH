//
//  CHDeviceInfoManager.m
//  CHDeviceInfoSDK
//
//  Created by 火虎MacBook on 2021/2/22.
//

#import "CHDeviceInfoManager.h"
#import"AFNetworkingTool.h"
#import "CHDeviceTool.h"

#define LaunchAPI @"/receive/launch"
#define RegisterAPI @"/receive/reg"
#define PayAPI @"/receive/pay"
@interface CHDeviceInfoManager()

@end

@implementation CHDeviceInfoManager

static CHDeviceInfoManager * _manager = nil;
+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[CHDeviceInfoManager alloc] init];
    });
    
    return _manager;
}

/**SDK初始化方法*/
-(void)initSDKWithHostUrl:(NSString *)hostUrl  APPID:(NSString *)appID{
    _manager.HostUrl = hostUrl;
    _manager.APPID = appID;
}

/**启动事件上报*/
-(void)startLaunchEvent{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    NSDictionary * deviceDic = [CHDeviceTool getDeviceAllInfoDic];
    params[@"deviceInfo"] = deviceDic;
    [[AFNetworkingTool sharedInstance] POST:[NSString stringWithFormat:@"%@%@",_manager.HostUrl,LaunchAPI] parameters:params success:^(NSInteger code, id  _Nullable json) {
        NSLog(@"启动事件上报成功%@",json);
        
    } failure:^(NSError * _Nullable error) {
        NSLog(@"启动事件上报:%@",error);
    }];
}

/**注册事件上报*/
-(void)startRegisterEvent{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    NSDictionary * deviceDic = [CHDeviceTool getDeviceAllInfoDic];
    params[@"deviceInfo"] = deviceDic;
    [[AFNetworkingTool sharedInstance] POST:[NSString stringWithFormat:@"%@%@",_manager.HostUrl,PayAPI] parameters:params success:^(NSInteger code, id  _Nullable json) {
        NSLog(@"注册事件上报成功%@",json);
        
    } failure:^(NSError * _Nullable error) {
        NSLog(@"注册事件上报:%@",error);
    }];
}

/**付费事件上报*/
-(void)startPayEventWithMoney:(NSString *)money{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    NSDictionary * deviceDic = [CHDeviceTool getDeviceAllInfoDic];
    params[@"deviceInfo"] = deviceDic;
    params[@"amount"] = money;
    [[AFNetworkingTool sharedInstance] POST:[NSString stringWithFormat:@"%@%@",_manager.HostUrl,RegisterAPI] parameters:params success:^(NSInteger code, id  _Nullable json) {
        NSLog(@"付费事件上报成功%@",json);
        
    } failure:^(NSError * _Nullable error) {
        NSLog(@"付费事件上报:%@",error);
    }];

}

@end
