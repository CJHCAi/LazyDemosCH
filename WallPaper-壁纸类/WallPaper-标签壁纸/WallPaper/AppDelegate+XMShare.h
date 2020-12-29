//
//  AppDelegate+XMShare.h
//  WallPaper
//
//  Created by ccpg_it on 2017/9/6.
//  Copyright © 2017年 Never. All rights reserved.
//

#import "AppDelegate.h"
#import "CommonMarco.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WeiboSDK.h"

@interface AppDelegate (XMShare)<WeiboSDKDelegate, QQApiInterfaceDelegate,WXApiDelegate>

- (void)init3rdParty;

@end
