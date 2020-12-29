//
//  HKUserInfo.h
//  HongKZH_IOS
//
//  Created by 王辉 on 2018/8/21.
//  Copyright © 2018年 hkzh. All rights reserved.
//
#import "JPUSHService.h"
#ifndef HKUserInfo_h
#define HKUserInfo_h
#define kAddress @"address"
#define kToken @"token"
#define kloginUid @"loginUid"
#define kUid @"Uid"
#define kName @"name"
#define kphoneNum @"kphoneNum"
//#define kUUID [[UIDevice currentDevice].identifierForVendor UUIDString]
#define kUUID [JPUSHService registrationID].length > 0?[JPUSHService registrationID]:@"1"
#define kNSUserDefaults [NSUserDefaults standardUserDefaults]
#endif /* HKUserInfo_h */
