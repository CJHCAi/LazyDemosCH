//
//  JRNavigationController.h
//  JR
//
//  Created by Zj on 17/8/18.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JRNavigationController : UINavigationController

/**
 是否允许右滑返回
 */
@property (nonatomic, assign, getter=isBackGestureEnable) BOOL backGestureEnable;

@end
