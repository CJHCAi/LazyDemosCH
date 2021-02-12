//
//  Student+CoreDataProperties.m
//  Class_03_CoreData
//
//  Created by wanghao on 16/3/10.
//  Copyright © 2016年 wanghao. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//


#import "Student+CoreDataProperties.h"

@implementation Student (CoreDataProperties)

//@dynamic告诉编译器,属性的setter与getter方法由用户自己实现，不自动生成。
//强迫必须写set和get，避免readOnly的属性
//在存储时CoreData会帮助生成set和get方法
@dynamic name;
@dynamic age;
@dynamic gender;
@dynamic relationship;


@end
