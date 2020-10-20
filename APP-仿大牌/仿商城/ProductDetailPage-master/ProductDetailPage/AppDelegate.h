//
//  AppDelegate.h
//  ProductDetailPage
//
//  Created by 方绍晟 on 2018/8/13.
//  Copyright © 2018年 fss_someThing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

