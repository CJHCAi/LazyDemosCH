//
//  Student.m
//  Class_03_CoreData
//
//  Created by wanghao on 16/3/10.
//  Copyright © 2016年 wanghao. All rights reserved.
//

#import "Student.h"

@implementation Student

// Insert code here to add functionality to your managed object subclass

-(NSString *)description
{
    NSString *str = [NSString stringWithFormat:@"姓名:%@,年龄:%d",self.name,self.age];
    
    return str;
}
@end
