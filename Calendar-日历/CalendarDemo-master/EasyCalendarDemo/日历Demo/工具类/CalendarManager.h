//
//  CalendarManager.h
//  QianBuXian_V2
//
//  Created by YangTianCi on 2018/4/4.
//  Copyright © 2018年 qbx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalenderObject.h"

/**
 
 主要优势:
 
 1.接口简单, 参数只有一个, 返回值利用也特别简单, 直接拆除对象使用即可 < 详细的对象拆解下方注释 >
 
 2.因为是工具类, 所以只涉及数据层面, 可以单独使用, 与界面无耦合度
 
 3.采用缓存机制, 在计算日历数据时可以避免多次运算, 提高运算效率
 
 4.采用自定义对象 < CalenderObject > 作为数据存储器, 可以对内容进行自定义扩展, 以满足业务需求
 
 5.对时间计算方式做了优化, 可以左右无限滑动, 且计算效率高
 
 6.Demo 中的日历界面为轮播图形式, 不会占用大量内存
 
 7.增加 CalenderObject 对象每天的 年月日 的 Int 表示方式, 更方便比对时间以及转换为格式检索字符串
 
 */

@interface CalendarManager : NSObject

//String: ?? 年 ?? 月

/**
 
 string: yyyy年MM月 形式的日期数据
 Array: 返回包含三个 CalenderObject 对象的数组, 此三个数据为月度数据对象包含了该月相关数据, 其中 DayArray 属性中包含了当月每天的数据, 分别为 CalenderObject 对象, 但是数据域只有每天的数据.
 CalenderObject: 其实是两个模型类的集合, 上班部分属性主要用于月度数据, 下半部分主要用于每天的数据
 
 */
-(NSArray<CalenderObject*>*)CaculateCurrentMonthWithString:(NSString*)string;

//功能二: 缓存字典: 可以根据 201803 类型的 Key 获取到此月份的日历数据对象, 最后完成缓存
@property (nonatomic, strong) NSMutableDictionary *cacheData;

#pragma mark ===== 自定义数据



@end
