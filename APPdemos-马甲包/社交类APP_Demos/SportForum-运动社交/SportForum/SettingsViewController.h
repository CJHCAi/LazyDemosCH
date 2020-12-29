//
//  SettingsViewController.h
//  SportForum
//
//  Created by zyshi on 14-9-12.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

enum
{
    SETTING_TYPE_IMAGE = 0,
    SETTING_TYPE_WEIGHT,
    SETTING_TYPE_HEIGHT,
    SETTING_TYPE_AGE,
    SETTING_TYPE_ALL
};

@interface SettingsViewController : BaseViewController

- (void)setType:(int)nType;

- (void)setUserLifePhotos;

@end
