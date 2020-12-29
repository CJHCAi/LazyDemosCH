//
//  HKVideoRecordTool.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/7/26.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKVideoRecordTool : NSObject

@property (nonatomic, weak) UIViewController *delegate;

- (instancetype)initWithDelegate:(UIViewController *)delegate;

+ (instancetype)videoRecordWithDelegate:(UIViewController *)delegate;

- (void)toRecordView;

@end
