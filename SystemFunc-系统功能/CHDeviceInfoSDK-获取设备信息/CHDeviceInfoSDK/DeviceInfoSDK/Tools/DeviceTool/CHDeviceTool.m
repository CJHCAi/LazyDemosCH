//
//  CHDeviceTool.m
//  CHVideoEditorDemo
//
//  Created by 火虎MacBook on 2020/11/7.
//  Copyright © 2020 Allen_Macbook Pro. All rights reserved.
//

#import "CHDeviceTool.h"
#import <sys/utsname.h>//获取设备版本
#import <AdSupport/AdSupport.h>//获取IDFA
#import "KeychainItemWrapper.h"//keychain存储
//获取设备的WIFI网络状态
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CoreLocation/CoreLocation.h>//获取位置权限

//获取设备的IP地址
#import <ifaddrs.h>
#import <arpa/inet.h>

@implementation CHDeviceTool
#define  SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define  SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define  isLiuHaiScreen  ((SCREEN_WIDTH == 375.f && SCREEN_HEIGHT == 812.f) || (SCREEN_WIDTH == 414.f && SCREEN_HEIGHT == 896.f))


#pragma mark - 设备信息

/**获取所有设备信息 返回设备信息Dic*/
+(NSDictionary *)getDeviceAllInfoDic{
    
    NSMutableDictionary * deviceParams = [NSMutableDictionary dictionary];
    //UUID
    NSString * UUID = [CHDeviceTool getUUID];
    [deviceParams setValue:UUID forKey:@"UUID"];
    //IDFA
    NSString * IDFA = [CHDeviceTool getIDFA];
    [deviceParams setValue:IDFA forKey:@"IDFA"];
    
    //获取UA
    NSString * UA = [CHDeviceTool getUA];
    [deviceParams setObject:UA forKey:@"UA"];

    //手机别名
    NSString * iphoneName = [CHDeviceTool getiphoneName];
    [deviceParams setValue:iphoneName forKey:@"iphoneName"];

    //系统名字
    NSString * systermName = [CHDeviceTool getSystemName];
    [deviceParams setValue:systermName forKey:@"systermName"];

    //系统版本
    NSString * systermVersion = [CHDeviceTool getSystemVersion];
    [deviceParams setValue:systermVersion forKey:@"systermVersion"];

    //手机容量
    NSString * memorySize = [CHDeviceTool getTotalmemorySize];
    [deviceParams setValue:memorySize forKey:@"memorySize"];
    
    //可用容量
    NSString * freeMemorySize = [CHDeviceTool getFreeMemorySize];
    [deviceParams setObject:freeMemorySize forKey:@"freeMemorySize"];
    
    //电池电量
    NSString * batteryLevel = [CHDeviceTool getBatteryLevel];
    [deviceParams setValue:batteryLevel forKey:@"batteryLevel"];


    //设备语言
    NSString * deviceLanguage = [CHDeviceTool getDeviceLanguage];
    [deviceParams setValue:deviceLanguage forKey:@"deviceLanguage"];
    
    //区域名称
    NSString * localPhoneModel = [CHDeviceTool getLocalPhoneModel];
    [deviceParams setObject:localPhoneModel forKey:@"localPhoneModel"];

    //手机型号
    NSString * iphoneModel = [CHDeviceTool getiphoneModel];
    [deviceParams setValue:iphoneModel forKey:@"iphoneModel"];

    //设备型号
    NSString * deviceModel = [CHDeviceTool getDeviceModelName];
    [deviceParams setValue:deviceModel forKey:@"deviceModel"];
    
    //获取网络状态
    NSString * networkType = [CHDeviceTool getNetworkType];
    [deviceParams setObject:networkType forKey:@"networkType"];
    
    //获取WIFI名字
    NSString * wifiName = [CHDeviceTool getWifiName];
    if (wifiName) {
        [deviceParams setObject:wifiName forKey:@"wifiName"];
    }
    
    //获取WIFI信息
    [CHDeviceTool getWifiInfo];

    //获取WIFI的MAC地址
    NSString * MACAdress = [CHDeviceTool getWifiMACAdress];
    if (MACAdress) {
        [deviceParams setObject:MACAdress forKey:@"MACAdress"];
    }
    
    //获取IP地址
    NSString * IPAddress = [CHDeviceTool getIPAddress];
    [deviceParams setObject:IPAddress forKey:@"IPAddress"];
    
    //APP名字
    NSString * APPName = [CHDeviceTool getAPPName];
    if (APPName) {
        [deviceParams setObject:APPName forKey:@"APPName"];
    }
    //APP版本
    NSString *APPVersion = [CHDeviceTool getAPPVersion];
    [deviceParams setValue:APPVersion forKey:@"appVersion"];
    
    //APP Build版本
    NSString * APPBuild = [CHDeviceTool getAPPBuild];
    [deviceParams setObject:APPBuild forKey:@"appBuild"];

    NSLog(@"deviceParams:%@",deviceParams);
    
    return deviceParams;
}

/**UUID又称IDFV 简介：iOS整个系统有一个KeyChain，每个程序都可以往KeyChain中记录数据，而且只能读取到自己程序记录在KeyChain中的数据。而且就算我们程序删除掉，系统经过升级以后再安装回来，依旧可以获取到与之前一致的UDID（系统还原、刷机除外）。因此我们可以将UUID的字符串存储到KeyChain中，然后下次直接从KeyChain获取UUID字符串。（本示例中使用KeychainItemWrapper工具类）
*/
//获取UUIDFrom Keychain,保证了卸载重装后UUID的唯一
+ (NSString *)getUUID{
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"com.ch.CHVideoEditorDemo" accessGroup:nil];
    //保存数据 保存一次即使删除程序 手机依旧保存其钥匙串   依旧可以由keychain获得
    NSString *UUIDString = [keychain objectForKey:(id)kSecAttrAccount];//账户名
    //  [keychain setObject:@"123456" forKey:(id)kSecValueData];//账户密码
    if (UUIDString == nil || UUIDString.length == 0) {
        UUIDString = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [keychain setObject:UUIDString forKey:(id)kSecAttrAccount];
    }
    return UUIDString;
}

/**简介：广告标示符，适用于对外：例如广告推广，换量等跨应用的用户追踪等。但如果用户完全重置系统（(设置程序 -> 通用 -> 还原 -> 还原位置与隐私) ，这个广告标示符会重新生成。另外如果用户明确的还原广告(设置程序-> 通用 -> 关于本机 -> 广告 -> 还原广告标示符) ，那么广告标示符也会重新生成。注意：如果程序在后台运行，此时用户“还原广告标示符”，然后再回到程序中，此时获取广 告标示符并不会立即获得还原后的标示符。必须要终止程序，然后再重新启动程序，才能获得还原后的广告标示符。在同一个设备上的所有App都会取到相同的值，是苹果专门给各广告提供商用来追踪用户而设的，
 用户可以在 设置 -> 隐私 -> 广告追踪 里重置此id的值，或限制此id的使用。
 注意：由于idfa会出现取不到的情况，故绝不可以作为业务分析的主id，来识别用户。 比如开启限制广告追踪
*/
+(NSString *)getIDFA{
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    return idfa;
}

/**获取UA*/
+(NSString *)getUA{
    UIWebView * webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString * userAgentString = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSLog(@"useragent = %@",userAgentString);
    return userAgentString;
}

/**手机别名*/
+(NSString *)getiphoneName{
    return [[UIDevice currentDevice] name];
}

/**获取当前系统名称*/
+ (NSString *)getSystemName{
    return [UIDevice currentDevice].systemName;
}

/**获取当前系统版本*/
+ (NSString *)getSystemVersion{
    return [UIDevice currentDevice].systemVersion;
}

/**
 *  手机型号
 *这个方法只能获取到iPhone、iPad这种信息
 *  @return e.g. iPhone
 */
+(NSString *)getiphoneModel{
    return [[UIDevice currentDevice] model];
}

/**获取电池电量*/
+ (NSString *)getBatteryLevel{
    CGFloat batteryLevel = [UIDevice currentDevice].batteryLevel;
    NSString * batteryLevelStr = [NSString stringWithFormat:@"%.0f",batteryLevel];
    NSLog(@"batteryLevelStr:%@",batteryLevelStr);
    return batteryLevelStr;
}

/**获取总内存大小 单位G*/
+ (NSString *)getTotalmemorySize{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *attributes = [fileManager attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    CGFloat memorySize = [attributes[NSFileSystemSize] doubleValue] / (powf(1024, 3));
    NSString * memorySizeStr = [NSString stringWithFormat:@"%.2fG",memorySize];
    NSLog(@"总内存:%@",memorySizeStr);
    
    return memorySizeStr;
}

/**可用内存 单位G*/
+(NSString *)getFreeMemorySize{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *attributes = [fileManager attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    CGFloat memorySize = [attributes[NSFileSystemFreeSize] doubleValue] / powf(1024, 3);
    NSString * memorySizeStr = [NSString stringWithFormat:@"%.2fG",memorySize];
    NSLog(@"可用内存:%@",memorySizeStr);

    return memorySizeStr;
}

/**获取当前语言*/
+ (NSString *)getDeviceLanguage{
    NSArray *languageArray = [NSLocale preferredLanguages];
    return [languageArray objectAtIndex:0];
}

/**地方型号  （国际化区域名称）*/
+(NSString *)getLocalPhoneModel{
    NSString* localPhoneModel = [[UIDevice currentDevice] localizedModel];
    NSLog(@"国际化区域名称:%@",localPhoneModel );
    
    return localPhoneModel;
}

/**
 *  设备型号名字
 *这个代码可以获取到具体的设备版本（已更新到iPhone 6s、iPhone 6s Plus），缺点是：采用的硬编码
 *这个方法可以通过AppStore的审核，放心用吧
 *  @return e.g. iPhone 5S
 */
+(NSString*)getDeviceModelName{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform hasPrefix:@"iPhone"]) {
        
        //------------------------------iPhone---------------------------
        if ([platform isEqualToString:@"iPhone13,1"]) return @"iPhone 12 mini";
        if ([platform isEqualToString:@"iPhone13,2"]) return @"iPhone 12";
        if ([platform isEqualToString:@"iPhone13,3"]) return @"iPhone 12 Pro";
        if ([platform isEqualToString:@"iPhone13,4"]) return @"iPhone 12 Pro Max";
        
        if ([platform isEqualToString:@"iPhone12,8"]) return @"iPhone SE 2";
        if ([platform isEqualToString:@"iPhone12,1"]) return @"iPhone 11";
        if ([platform isEqualToString:@"iPhone12,3"]) return @"iPhone 11 Pro";
        if ([platform isEqualToString:@"iPhone12,5"]) return @"iPhone 11 Pro Max";
        
        if ([platform isEqualToString:@"iPhone11,8"]) return @"iPhone XR";
        if ([platform isEqualToString:@"iPhone11,2"]) return @"iPhone XS";
        if ([platform isEqualToString:@"iPhone11,4"] ||
            [platform isEqualToString:@"iPhone11,6"]) return @"iPhone XS Max";
        
        if ([platform isEqualToString:@"iPhone10,1"] ||
            [platform isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
        if ([platform isEqualToString:@"iPhone10,2"] ||
            [platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
        if ([platform isEqualToString:@"iPhone10,3"] ||
            [platform isEqualToString:@"iPhone10,6"]) return @"iPhone X";
        
        if ([platform isEqualToString:@"iPhone9,1"] ||
            [platform isEqualToString:@"iPhone9,3"]) return @"iPhone 7";
        if ([platform isEqualToString:@"iPhone9,2"] ||
            [platform isEqualToString:@"iPhone9,4"]) return @"iPhone 7 Plus";
        
        if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
        if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
        if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
        
        if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
        if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
        
        if ([platform isEqualToString:@"iPhone6,1"] ||
            [platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
        
        if ([platform isEqualToString:@"iPhone5,1"] ||
            [platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
        if ([platform isEqualToString:@"iPhone5,3"] ||
            [platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
        
        if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
        
        if ([platform isEqualToString:@"iPhone3,1"] ||
            [platform isEqualToString:@"iPhone3,2"] ||
            [platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
        
        if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
        if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
        if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
        
        
    }else if ([platform hasPrefix:@"iPad"]){
        
        //------------------------------iPad--------------------------
        if ([platform isEqualToString:@"iPad1,1"]) return @"iPad";
        if ([platform isEqualToString:@"iPad2,1"] ||
            [platform isEqualToString:@"iPad2,2"] ||
            [platform isEqualToString:@"iPad2,3"] ||
            [platform isEqualToString:@"iPad2,4"]) return @"iPad 2";
        if ([platform isEqualToString:@"iPad3,1"] ||
            [platform isEqualToString:@"iPad3,2"] ||
            [platform isEqualToString:@"iPad3,3"]) return @"iPad 3";
        if ([platform isEqualToString:@"iPad3,4"] ||
            [platform isEqualToString:@"iPad3,5"] ||
            [platform isEqualToString:@"iPad3,6"]) return @"iPad 4";
        if ([platform isEqualToString:@"iPad6,11"] ||
            [platform isEqualToString:@"iPad6,12"]) return @"iPad 5";
        if ([platform isEqualToString:@"iPad7,5"] ||
            [platform isEqualToString:@"iPad7,6"]) return @"iPad 6";
        if ([platform isEqualToString:@"iPad7,11"] ||
            [platform isEqualToString:@"iPad7,12"]) return @"iPad 7";
        if ([platform isEqualToString:@"iPad11,6"] ||
            [platform isEqualToString:@"iPad11,7"]) return @"iPad 8";
        
        //------------------------------iPad Air--------------------------
        if ([platform isEqualToString:@"iPad4,1"] ||
            [platform isEqualToString:@"iPad4,2"] ||
            [platform isEqualToString:@"iPad4,3"]) return @"iPad Air";
        if ([platform isEqualToString:@"iPad5,3"] ||
            [platform isEqualToString:@"iPad5,4"]) return @"iPad Air 2";
        
        if ([platform isEqualToString:@"iPad11,3"] ||
            [platform isEqualToString:@"iPad11,4"]) return @"iPad Air 3";
        
        if ([platform isEqualToString:@"iPad13,1"] ||
            [platform isEqualToString:@"iPad12,2"]) return @"iPad Air 4";
        
        //------------------------------iPad Pro--------------------------
        if ([platform isEqualToString:@"iPad6,3"] ||
            [platform isEqualToString:@"iPad6,4"]) return @"iPad Pro 9.7-inch";
        if ([platform isEqualToString:@"iPad6,7"] ||
            [platform isEqualToString:@"iPad6,8"]) return @"iPad Pro 12.9-inch";
        
        if ([platform isEqualToString:@"iPad7,1"] ||
            [platform isEqualToString:@"iPad7,2"]) return @"iPad Pro 12.9-inch 2";
        if ([platform isEqualToString:@"iPad7,3"] ||
            [platform isEqualToString:@"iPad7,4"]) return @"iPad Pro 10.5-inch";
       
        if ([platform isEqualToString:@"iPad8,1"] ||
            [platform isEqualToString:@"iPad8,2"] ||
            [platform isEqualToString:@"iPad8,3"] ||
            [platform isEqualToString:@"iPad8,4"]) return @"iPad Pro 11-inch";
        if ([platform isEqualToString:@"iPad8,5"] ||
            [platform isEqualToString:@"iPad8,6"] ||
            [platform isEqualToString:@"iPad8,7"] ||
            [platform isEqualToString:@"iPad8,8"]) return @"iPad Pro 12.9-inch 3";
        if ([platform isEqualToString:@"iPad8,9"] ||
            [platform isEqualToString:@"iPad8,10"]) return @"iPad Pro 11-inch 2";
        if ([platform isEqualToString:@"iPad8,11"] ||
            [platform isEqualToString:@"iPad8,12"]) return @"iPad Pro 12.9-inch 4";
        
        //------------------------------iPad Mini-----------------------
        if ([platform isEqualToString:@"iPad2,5"] ||
            [platform isEqualToString:@"iPad2,6"] ||
            [platform isEqualToString:@"iPad2,7"]) return @"iPad mini";
        if ([platform isEqualToString:@"iPad4,4"] ||
            [platform isEqualToString:@"iPad4,5"] ||
            [platform isEqualToString:@"iPad4,6"]) return @"iPad mini 2";
        if ([platform isEqualToString:@"iPad4,7"] ||
            [platform isEqualToString:@"iPad4,8"] ||
            [platform isEqualToString:@"iPad4,9"]) return @"iPad mini 3";
        if ([platform isEqualToString:@"iPad5,1"] ||
            [platform isEqualToString:@"iPad5,2"]) return @"iPad mini 4";
        if ([platform isEqualToString:@"iPad11,1"] ||
            [platform isEqualToString:@"iPad11,2"]) return @"iPad mini 5";
    }else{
        //------------------------------iPod touch------------------------
        if ([platform isEqualToString:@"iPod1,1"]) return @"iTouch";
        if ([platform isEqualToString:@"iPod2,1"]) return @"iTouch2";
        if ([platform isEqualToString:@"iPod3,1"]) return @"iTouch3";
        if ([platform isEqualToString:@"iPod4,1"]) return @"iTouch4";
        if ([platform isEqualToString:@"iPod5,1"]) return @"iTouch5";
        if ([platform isEqualToString:@"iPod7,1"]) return @"iTouch6";
        if ([platform isEqualToString:@"iPod9,1"]) return @"iTouch7";
        
        //------------------------------Samulitor-------------------------------------
        if ([platform isEqualToString:@"i386"] ||
            [platform isEqualToString:@"x86_64"]) return @"iPhone Simulator";
    }
    

    return platform;
    
}

#pragma mark - 网络配置
/**获取设备网络状态*/
+ (NSString *)getNetworkType{
    UIApplication *app = [UIApplication sharedApplication];
    id statusBar = nil;
//    判断是否是iOS 13
    NSString *network = @"";
    if (@available(iOS 13.0, *)) {
        UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].keyWindow.windowScene.statusBarManager;
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        if ([statusBarManager respondsToSelector:@selector(createLocalStatusBar)]) {
            UIView *localStatusBar = [statusBarManager performSelector:@selector(createLocalStatusBar)];
            if ([localStatusBar respondsToSelector:@selector(statusBar)]) {
                statusBar = [localStatusBar performSelector:@selector(statusBar)];
            }
        }
#pragma clang diagnostic pop
        
        if (statusBar) {
//            UIStatusBarDataCellularEntry
            id currentData = [[statusBar valueForKeyPath:@"_statusBar"] valueForKeyPath:@"currentData"];
            id _wifiEntry = [currentData valueForKeyPath:@"wifiEntry"];
            id _cellularEntry = [currentData valueForKeyPath:@"cellularEntry"];
            if (_wifiEntry && [[_wifiEntry valueForKeyPath:@"isEnabled"] boolValue]) {
//                If wifiEntry is enabled, is WiFi.
                network = @"WIFI";
            } else if (_cellularEntry && [[_cellularEntry valueForKeyPath:@"isEnabled"] boolValue]) {
                NSNumber *type = [_cellularEntry valueForKeyPath:@"type"];
                if (type) {
                    switch (type.integerValue) {
                        case 0:
//                            无sim卡
                            network = @"NONE";
                            break;
                        case 1:
                            network = @"1G";
                            break;
                        case 4:
                            network = @"3G";
                            break;
                        case 5:
                            network = @"4G";
                            break;
                        default:
//                            默认WWAN类型
                            network = @"WWAN";
                            break;
                            }
                        }
                    }
                }
    }else {
        statusBar = [app valueForKeyPath:@"statusBar"];
        
        if (isLiuHaiScreen) {
//            刘海屏
                id statusBarView = [statusBar valueForKeyPath:@"statusBar"];
                UIView *foregroundView = [statusBarView valueForKeyPath:@"foregroundView"];
                NSArray *subviews = [[foregroundView subviews][2] subviews];
                
                if (subviews.count == 0) {
//                    iOS 12
                    id currentData = [statusBarView valueForKeyPath:@"currentData"];
                    id wifiEntry = [currentData valueForKey:@"wifiEntry"];
                    if ([[wifiEntry valueForKey:@"_enabled"] boolValue]) {
                        network = @"WIFI";
                    }else {
//                    卡1:
                        id cellularEntry = [currentData valueForKey:@"cellularEntry"];
//                    卡2:
                        id secondaryCellularEntry = [currentData valueForKey:@"secondaryCellularEntry"];

                        if (([[cellularEntry valueForKey:@"_enabled"] boolValue]|[[secondaryCellularEntry valueForKey:@"_enabled"] boolValue]) == NO) {
//                            无卡情况
                            network = @"NONE";
                        }else {
//                            判断卡1还是卡2
                            BOOL isCardOne = [[cellularEntry valueForKey:@"_enabled"] boolValue];
                            int networkType = isCardOne ? [[cellularEntry valueForKey:@"type"] intValue] : [[secondaryCellularEntry valueForKey:@"type"] intValue];
                            switch (networkType) {
                                    case 0://无服务
                                    network = [NSString stringWithFormat:@"%@-%@", isCardOne ? @"Card 1" : @"Card 2", @"NONE"];
                                    break;
                                    case 3:
                                    network = [NSString stringWithFormat:@"%@-%@", isCardOne ? @"Card 1" : @"Card 2", @"2G/E"];
                                    break;
                                    case 4:
                                    network = [NSString stringWithFormat:@"%@-%@", isCardOne ? @"Card 1" : @"Card 2", @"3G"];
                                    break;
                                    case 5:
                                    network = [NSString stringWithFormat:@"%@-%@", isCardOne ? @"Card 1" : @"Card 2", @"4G"];
                                    break;
                                default:
                                    break;
                            }
                            
                        }
                    }
                
                }else {
                    
                    for (id subview in subviews) {
                        if ([subview isKindOfClass:NSClassFromString(@"_UIStatusBarWifiSignalView")]) {
                            network = @"WIFI";
                        }else if ([subview isKindOfClass:NSClassFromString(@"_UIStatusBarStringView")]) {
                            network = [subview valueForKeyPath:@"originalText"];
                        }
                    }
                }
                
            }else {
//                非刘海屏
                UIView *foregroundView = [statusBar valueForKeyPath:@"foregroundView"];
                NSArray *subviews = [foregroundView subviews];
                
                for (id subview in subviews) {
                    if ([subview isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
                        int networkType = [[subview valueForKeyPath:@"dataNetworkType"] intValue];
                        switch (networkType) {
                            case 0:
                                network = @"NONE";
                                break;
                            case 1:
                                network = @"2G";
                                break;
                            case 2:
                                network = @"3G";
                                break;
                            case 3:
                                network = @"4G";
                                break;
                            case 5:
                                network = @"WIFI";
                                break;
                            default:
                                break;
                        }
                    }
                }
            }
    }

    if ([network isEqualToString:@""]) {
        network = @"NO DISPLAY";
    }
    return network;
}

/**获取WIFI信息*/
+(id)getWifiInfo{
    
    //获取位置权限
    if (@available(ios 13.0,*)) {
        //如果是iOS13以后 未开启地理位置权限 需要提示一下
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
            CLLocationManager * locationManager = [[CLLocationManager alloc] init];
            [locationManager requestWhenInUseAuthorization];
        }
    }
    
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        
        if (info && [info count]) {
            break;
        }
    }
    NSLog(@"WIFI信息:%@",info);
    return info;
}

/**获取WIFI名字*/
+(NSString *)getWifiName{
    return (NSString *)[CHDeviceTool getWifiInfo][@"SSID"];
}

/**获取WIFI的MAC地址*/
+(NSString *)getWifiMACAdress{
    return (NSString *)[CHDeviceTool getWifiInfo][@"BSSID"];
}

/**获取当前的Wifi信号强度*/
+ (int)getWifiSignalStrength{
    int signalStrength = 0;
//    判断类型是否为WIFI
    if ([[self getNetworkType]isEqualToString:@"WIFI"]) {
//        判断是否为iOS 13
        if (@available(iOS 13.0, *)) {
            UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].keyWindow.windowScene.statusBarManager;
             
            id statusBar = nil;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
            if ([statusBarManager respondsToSelector:@selector(createLocalStatusBar)]) {
                UIView *localStatusBar = [statusBarManager performSelector:@selector(createLocalStatusBar)];
                if ([localStatusBar respondsToSelector:@selector(statusBar)]) {
                    statusBar = [localStatusBar performSelector:@selector(statusBar)];
                }
            }
#pragma clang diagnostic pop
            if (statusBar) {
                id currentData = [[statusBar valueForKeyPath:@"_statusBar"] valueForKeyPath:@"currentData"];
                id wifiEntry = [currentData valueForKeyPath:@"wifiEntry"];
                if ([wifiEntry isKindOfClass:NSClassFromString(@"_UIStatusBarDataIntegerEntry")]) {
//                    层级：_UIStatusBarDataNetworkEntry、_UIStatusBarDataIntegerEntry、_UIStatusBarDataEntry
                    
                    signalStrength = [[wifiEntry valueForKey:@"displayValue"] intValue];
                }
            }
        }else {
            UIApplication *app = [UIApplication sharedApplication];
            id statusBar = [app valueForKey:@"statusBar"];
            if (isLiuHaiScreen) {
//                刘海屏
                id statusBarView = [statusBar valueForKeyPath:@"statusBar"];
                UIView *foregroundView = [statusBarView valueForKeyPath:@"foregroundView"];
                NSArray *subviews = [[foregroundView subviews][2] subviews];
                       
                if (subviews.count == 0) {
//                    iOS 12
                    id currentData = [statusBarView valueForKeyPath:@"currentData"];
                    id wifiEntry = [currentData valueForKey:@"wifiEntry"];
                    signalStrength = [[wifiEntry valueForKey:@"displayValue"] intValue];
//                    dBm
//                    int rawValue = [[wifiEntry valueForKey:@"rawValue"] intValue];
                }else {
                    for (id subview in subviews) {
                        if ([subview isKindOfClass:NSClassFromString(@"_UIStatusBarWifiSignalView")]) {
                            signalStrength = [[subview valueForKey:@"_numberOfActiveBars"] intValue];
                        }
                    }
                }
            }else {
//                非刘海屏
                UIView *foregroundView = [statusBar valueForKey:@"foregroundView"];
                     
                NSArray *subviews = [foregroundView subviews];
                NSString *dataNetworkItemView = nil;
                       
                for (id subview in subviews) {
                    if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
                        dataNetworkItemView = subview;
                        break;
                    }
                }
                       
                signalStrength = [[dataNetworkItemView valueForKey:@"_wifiStrengthBars"] intValue];
                        
                return signalStrength;
            }
        }
    }
    return signalStrength;
}

/**获取设备IP地址*/
+ (NSString *)getIPAddress{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // 检索当前接口,在成功时,返回0
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // 循环链表的接口
        temp_addr = interfaces;
        while(temp_addr != NULL) {
//                开热点时本机的IP地址
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"bridge100"]
                    ) {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // 检查接口是否en0 wifi连接在iPhone上
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // 得到NSString从C字符串
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // 释放内存
    freeifaddrs(interfaces);
    return address;
}

#pragma mark - app的信息
/**获取app版本号*/
+ (NSString *)getAPPVersion{
    NSString * APPVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return APPVersion;
}

/**获取APPBuild版本*/
+(NSString *)getAPPBuild{
    NSString *appBuild = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    return appBuild;
}
/**获取APP名字*/
+(NSString *)getAPPName{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];

    return appName;
}


@end
