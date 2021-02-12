//
//  Student+CoreDataProperties.h
//  Class_03_CoreData
//
//  Created by wanghao on 16/3/10.
//  Copyright © 2016年 wanghao. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Student.h"

NS_ASSUME_NONNULL_BEGIN

@interface Student (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nonatomic) int32_t age;
@property (nullable, nonatomic, retain) NSString *gender;
@property (nullable, nonatomic, retain) NSManagedObject *relationship;

@end

NS_ASSUME_NONNULL_END
