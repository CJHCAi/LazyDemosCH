//
//  CHDeviceTool.h
//  CHVideoEditorDemo
//
//  Created by 火虎MacBook on 2020/11/7.
//  Copyright © 2020 Allen_Macbook Pro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CHDeviceTool : NSObject
#pragma mark - 设备信息
/**获取所有设备信息 返回设备信息Dic*/
+(NSDictionary *)getDeviceAllInfoDic;
/**获取UUIDFrom Keychain,保证了卸载重装后UUID的唯一*/
+ (NSString *)getUUID;
/**获取IDFA  由于idfa会出现取不到的情况，故绝不可以作为业务分析的主id，来识别用户。 比如开启限制广告追踪*/
+(NSString *)getIDFA;
/**获取UA*/
+(NSString *)getUA;
/**手机别名*/
+(NSString *)getiphoneName;
/**获取当前系统名称*/
+ (NSString *)getSystemName;
/**获取当前系统版本*/
+ (NSString *)getSystemVersion;
/**获取当前语言*/
+ (NSString *)getDeviceLanguage;
/**地方型号  （国际化区域名称）*/
+(NSString *)getLocalPhoneModel;
/**手机型号;这个方法只能获取到iPhone、iPad这种信息 */
+(NSString *)getiphoneModel;
/**
 *  设备型号名字
 *这个代码可以获取到具体的设备版本（已更新到iPhone 6s、iPhone 6s Plus, e.g. iPhone 5S），缺点是：采用的硬编码
 * */
+ (NSString*)getDeviceModelName;

/**获取总内存大小 单位G*/
+ (NSString *)getTotalmemorySize;
/**可用内存 单位G*/
+(NSString *)getFreeMemorySize;
/**获取电池电量*/
+ (NSString *)getBatteryLevel;

#pragma mark - 网络信息
/**获取设备网络状态*/
+ (NSString *)getNetworkType;
/**获取WIFI名字*/
+(NSString *)getWifiName;
/**获取WIFI信息*/
+(id)getWifiInfo;
/**获取当前的Wifi信号强度*/
+ (int)getWifiSignalStrength;
/**获取设备IP地址*/
+ (NSString *)getIPAddress;
/**获取WIFI的MAC地址*/
+(NSString *)getWifiMACAdress;

#pragma mark - APP信息
// 获取app版本号
+ (NSString *)getAPPVersion;
/**获取APPBuild版本*/
+(NSString *)getAPPBuild;
/**获取APP名字*/
+(NSString *)getAPPName;

@end

NS_ASSUME_NONNULL_END
