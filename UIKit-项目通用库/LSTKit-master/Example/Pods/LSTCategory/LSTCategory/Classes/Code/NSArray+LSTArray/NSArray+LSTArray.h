//
//  NSArray+LSTArray.h
//  DYwttai
//
//  Created by LoSenTrad on 2017/5/5.
//  Copyright © 2017年 dongyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (LSTArray)
/**
 *  数组转字符串
 *  @param separator 分隔符
 */
- (NSString *)arrayToStringWithSeparator:(NSString *)separator;

/** 检测是空字符串还是数组 */
- (NSArray *)checkResponse;
///冒泡排序
- (NSArray *)change:(NSMutableArray *)array;
@end
