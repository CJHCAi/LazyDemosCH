//
//  BaiduMobAdDubaoDelegate.h
//  BaiduMobAdSDK
//
//  Created by baidu on 16/7/24.
//  Copyright © 2016年 Baidu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaiduMobAdCommonConfig.h"



@protocol BaiduMobAdDubaoDelegate <NSObject>

@required
/**
 *  应用的APPID
 */
- (NSString *)publisherId;

@optional


/**
 *  启动位置信息
 */
-(BOOL) enableLocation;


/**
 *  广告展示结束
 */
- (void)duBaoDidDismissScreen;




@end
