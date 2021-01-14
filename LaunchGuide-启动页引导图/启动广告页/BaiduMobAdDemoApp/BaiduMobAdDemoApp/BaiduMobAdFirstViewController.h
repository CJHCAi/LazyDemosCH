//
//  BaiduMobAdFirstViewController.h
//  APIExampleApp
//
//  Created by jaygao on 11-10-26.
//  Copyright (c) 2011年 Baidu,Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaiduMobAdSDK/BaiduMobAdDelegateProtocol.h"

@interface BaiduMobAdFirstViewController : UIViewController<BaiduMobAdViewDelegate>
{
    BaiduMobAdView* sharedAdView;
}

@end



