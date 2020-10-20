//
//  RRDevice.h
//  PhotoCollage
//
//  Created by Rongrong Lai on 12-3-21.
//  Copyright (c) 2012年 ILRRONG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

enum {
    RRDevice_Unknow = 0,
    RRDevice_iPhone1G,
    RRDevice_iPhone3G,
    RRDevice_iPhone3GS,
    RRDevice_iPhone4,
    RRDevice_iPhone4S,
    RRDevice_iPodTouch1G,
    RRDevice_iPodTouch2G,
    RRDevice_iPodTouch3G,
    RRDevice_iPodTouch4G,
    RRDevice_iPad,
    RRDevice_iPad2,
    RRDevice_iPad3,
    RRDevice_Simulator
};
typedef NSUInteger RRDeviceIdentifier;

enum {
    LanguageZhHans = 1,
    LanguageZhHant = 2,
    LanguageEnglish = 3
};
typedef NSUInteger WJLanguage;

@interface RRDevice : NSObject

+ (BOOL)deviceIsRetina;
+ (NSInteger)systemVersionNumber;
+ (RRDeviceIdentifier)getDeviceIdentifier;
+ (BOOL)deviceIsBelowA5CPU;
+ (BOOL)deviceIsIPhone5;
+ (BOOL)deviceIsIPhone4;
+ (UIInterfaceOrientation)deviceInterfaceOrientation;
+ (NSInteger)getCurrentLanguage;
+ (NSString *)appVersion;
+ (NSString *)systemVersion;
+ (NSString *)macAddress;
+ (NSString *)deviceModel;
+ (BOOL)isJailBroken;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com