//
//  MYZTools.h
//  MYZWebHybrid
//
//  Created by MA806P on 2019/2/23.
//  Copyright © 2019 myz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYZTools : NSObject

/// 弹框显示信息，2秒后消失
+ (void)showMessage:(NSString *)message;
/// 弹框显示信息，几秒后消失
+(void)showMessage:(NSString *)message delay:(NSTimeInterval)delay;
//系统AlertView显示
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message;
/// 判断字符串是否为空
+ (BOOL)is_stringEmpty:(NSString *)string;
/// 判断是否为数组类型
+ (BOOL)is_array:(NSArray *)array;
/// 判断是否为字典类型
+ (BOOL)is_dcitionary:(NSDictionary *)dic;

@end
