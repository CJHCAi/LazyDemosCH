//
//  CHDeviceInfoController.m
//  CHDeviceInfoSDK
//
//  Created by 火虎MacBook on 2021/2/22.
//

#import "CHDeviceInfoController.h"
#import "CHDeviceTool.h"
#import "CHDeviceInfoManager.h"

@interface CHDeviceInfoController ()

@end

@implementation CHDeviceInfoController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //获取设备信息
//    [self getDeviceInfo];
    
    [[CHDeviceInfoManager shareInstance] startLaunchEvent];
}


@end
