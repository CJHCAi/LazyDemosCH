//
//  ControllerPushHelper.h
//  Desktop
//
//  Created by 罗泰 on 2018/11/20.
//  Copyright © 2018 chenwang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 页面跳转帮助类
 */
@interface ControllerPushHelper : NSObject

+ (instancetype)sharedHelper;

- (void)pushControllerWithopenURL:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
