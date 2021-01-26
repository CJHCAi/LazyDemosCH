//
//  AppDelegate.h
//  Class_03_CoreData
//
//  Created by wanghao on 16/3/10.
//  Copyright © 2016年 wanghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//被管理对象的上下文，相当于一个数据库
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//数据的存储模型
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
//持久化数据协调器，相当于秘书
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
//沙盒路径
- (NSURL *)applicationDocumentsDirectory;


@end

