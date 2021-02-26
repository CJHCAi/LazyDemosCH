//
//  AppDelegate.m
//  CHDeviceInfoSDK
//
//  Created by 火虎MacBook on 2021/2/22.
//

#import "AppDelegate.h"
#import "CHDeviceInfoController.h"
#import "CHDeviceInfoManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //SDK初始化
    [[CHDeviceInfoManager shareInstance] initSDKWithHostUrl:@"http://121.89.204.35" APPID:@"666888"];

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[CHDeviceInfoController alloc] init];
    [self.window makeKeyAndVisible];
    
    
    return YES;
}




@end
