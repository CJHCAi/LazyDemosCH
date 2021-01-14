//
//  BaiduMobAdDubaoController.h
//  XAdSDKDevSample
//
//  Created by baidu on 16/7/28.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaiduMobAdSDK/BaiduMobAdDubaoDelegate.h"
#import "BaiduMobAdSDK/BaiduMobAdDubao.h"

@interface BaiduMobAdDubaoController : UIViewController<BaiduMobAdDubaoDelegate>

@property (nonatomic, retain) BaiduMobAdDubao *dubao;

@end
