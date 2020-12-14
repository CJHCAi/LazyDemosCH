//
//  BaiduMobAdChuileiController.h
//  XAdSDKDevSample
//
//  Created by lishan04 on 16/7/11.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaiduMobAdSDK/BaiduMobAdChuilei.h"
#import "BaiduMobAdSDK/BaiduMobAdChuileiAdDelegate.h"

@interface BaiduMobAdChuileiController : UIViewController <BaiduMobAdChuileiAdDelegate
>
@property (nonatomic, retain) BaiduMobAdChuilei *chuilei;
@property (nonatomic, retain) NSMutableArray *adViewArray;
@property (nonatomic, copy)   NSString*toBeChangedApid;
@property (nonatomic, copy)   NSString*toBeChangedPublisherId;
@end
