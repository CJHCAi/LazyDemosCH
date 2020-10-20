/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import <Foundation/Foundation.h>

@interface NSDateFormatter (Category)
/**初始化对象*/
+ (id)dateFormatter;
/**初始化指定格式对象*/
+ (id)dateFormatterWithFormat:(NSString *)dateFormat;
/**初始化yyyy-MM-dd HH:mm:ss默认格式对象*/
+ (id)defaultDateFormatter;/*yyyy-MM-dd HH:mm:ss*/

@end
