//
//  HK_SingleColumnPickerView.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/14.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CallbcakBlock)(NSString *value, NSInteger index);

@interface HK_SingleColumnPickerView : UIView

@property (nonatomic, copy) CallbcakBlock callBackBlock;

+ (instancetype)showWithData:(NSArray *)titles callBackBlock:(CallbcakBlock)block;

@end
