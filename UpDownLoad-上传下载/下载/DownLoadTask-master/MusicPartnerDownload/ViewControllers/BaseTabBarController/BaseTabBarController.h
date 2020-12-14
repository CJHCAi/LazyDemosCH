//
//  BaseTabBarController.h
//  MusicPartnerDownload
//
//  GitHub:https://github.com/szweee
//  Blog:  http://www.szweee.com
//
//  Created by 索泽文 on 16/2/10.
//  Copyright © 2016年 索泽文. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, Enum_TabBar_Item) {
    /* 发现 */
    Enum_TabBar_Items_Discovre,
    /* 下载 */
    Enum_TabBar_Items_DownLoad,
    /* 我的 */
    Enum_TabBar_Items_Mine
};


@interface BaseTabBarController : UITabBarController

@end
