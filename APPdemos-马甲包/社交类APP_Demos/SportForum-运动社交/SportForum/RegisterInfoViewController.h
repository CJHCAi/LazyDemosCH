//
//  RegisterInfoViewController.h
//  SportForum
//
//  Created by liyuan on 4/9/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <ShareSDK/ShareSDK.h>

enum
{
    REGISTER_NIKENAME_PAGE,
    REGISTER_USERINFO_PAGE,
};

@interface RegisterInfoViewController : BaseViewController

@property(nonatomic, assign) NSUInteger nRegisterType;

@property(nonatomic, assign) id<ISSPlatformUser> userWeiboInfo;

@end
