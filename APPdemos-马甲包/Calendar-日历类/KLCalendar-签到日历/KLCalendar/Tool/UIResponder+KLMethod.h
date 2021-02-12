//
//  UIResponder+KLMethod.h
//  KLCalendar
//
//  Created by kai lee on 16/7/26.
//  Copyright © 2016年 kai lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (KLMethod)
//参数为空处理返回值不是数字
+(NSString *)isNullClassDataString:(NSString *)dataString;

//参数为空处理返回值是数字
+(NSString *)isNullNumberDataString:(NSString *)numbertring;
//数组为空处理
+(NSArray *)isNullClassDataArray:(NSArray *)dataArray;
@end
