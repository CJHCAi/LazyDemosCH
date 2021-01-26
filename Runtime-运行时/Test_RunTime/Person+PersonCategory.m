//
//  Person+PersonCategory.m
//  Test_RunTime
//
//  Created by wanghao on 16/5/28.
//  Copyright © 2016年 wanghao. All rights reserved.
//

#import "Person+PersonCategory.h"
#import <objc/runtime.h>

const char * str = "myKey";//作为key，字符常量，必须是c语言字符串
@implementation Person (PersonCategory)

- (void)setHeight:(float)height
{
    NSNumber *num = [NSNumber numberWithFloat:height];
    /*
     第一个参数是需要添加属性的对象；
     第二个参数是属性的key
     第三个参数是属性的值，类型必须为id，所有height转为NSNumber类型
     第四个参数是使用策略，是一个枚举值，类似@property属性创建时设置的关键帧，可以从命名看错个枚举的意义；
     */
    objc_setAssociatedObject(self, str, num, OBJC_ASSOCIATION_ASSIGN);
}

//提取属性的值
- (float)height
{
    NSNumber *number = objc_getAssociatedObject(self, str);
    return [number floatValue];
}

@end
