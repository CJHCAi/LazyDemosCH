//
//  Person.m
//  Test_RunTime
//
//  Created by wanghao on 16/5/28.
//  Copyright © 2016年 wanghao. All rights reserved.
//

#import "Person.h"

@interface Person ()
@property (nonatomic,retain) NSString *name; //实例变量

@end

@implementation Person

//初始化person属性
-(instancetype)init{
    self = [super init];
    if(self) {
        _name = @"Tom";
        self.age = 12;
    }
    return self;
}
//person的2个普通方法
-(void)func1{
    NSLog(@"执行func1方法。");
}

-(void)func2{
    NSLog(@"执行func2方法。");
}

//输出person对象时的方法：
-(NSString *)description{
    return [NSString stringWithFormat:@"name:%@ age:%d",_name,self.age];
}
@end
