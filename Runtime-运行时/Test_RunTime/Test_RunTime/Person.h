//
//  Person.h
//  Test_RunTime
//
//  Created by wanghao on 16/5/28.
//  Copyright © 2016年 wanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject
@property (nonatomic,assign)int age;  //属性变量
@property (nonatomic,retain) NSDictionary *dic;
@property (nonatomic,assign) float ss;
-(void)func1;
-(void)func2;
@end
