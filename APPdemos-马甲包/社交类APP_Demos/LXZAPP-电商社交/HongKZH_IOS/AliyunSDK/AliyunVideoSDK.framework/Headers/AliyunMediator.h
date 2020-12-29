//
//  AliyunMediator.h
//  AliyunVideo
//
//  Created by Worthy on 2017/5/4.
//  Copyright © 2017年 Alibaba Group Holding Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AliyunMediator : NSObject

+ (instancetype)shared;

- (UIViewController *)recordModule;
- (UIViewController *)magicCameraModule;
- (UIViewController *)editModule;
- (UIViewController *)cropModule;
- (UIViewController *)liveModule;
- (UIViewController *)uiComponentModule;

- (UIViewController *)configureViewController;
- (UIViewController *)recordViewController;
- (UIViewController *)compositionViewController;
- (UIViewController *)editViewController;
- (UIViewController *)cropViewController;
- (UIViewController *)photoViewController;

@end
