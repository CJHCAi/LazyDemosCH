//
//  NextViewController.h
//  Desktop
//
//  Created by 罗泰 on 2018/11/6.
//  Copyright © 2018 chenwang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class Module;

@interface NextViewController : UIViewController
@property (nonatomic, strong) Module                *model;

- (instancetype)initWithModel:(Module *)model;
@end

NS_ASSUME_NONNULL_END
