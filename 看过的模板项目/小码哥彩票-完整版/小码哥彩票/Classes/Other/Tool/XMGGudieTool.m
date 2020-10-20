//
//  XMGGudieTool.m
//  小码哥彩票
//
//  Created by xiaomage on 15/7/1.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//
#define XMGVersionKey @"version"

#import "XMGGudieTool.h"

#import "XMGTabBarController.h"
#import "XMGNewFeatureViewController.h"
#import "XMGSaveTool.h"


@implementation XMGGudieTool

+ (UIViewController *)chooseRootViewController
{
    // 判断下有没有最新的版本号
    NSString *curVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    // 获取上一次版本号
    NSString *oldVersion = [XMGSaveTool objectForKey:XMGVersionKey];
    UIViewController *rootVc = nil;
    
    if ([curVersion isEqualToString:oldVersion]) {
        // 没有最新的版本号,进入核心界面
        rootVc = [[XMGTabBarController alloc] init];
        
    }else{
        // 有最新的版本号，进入新特性界面,保存当前的最新版本号
        rootVc = [[XMGNewFeatureViewController alloc] init];
//        rootVc = [[XMGTabBarController alloc] init];
        [XMGSaveTool setObject:curVersion forKey:XMGVersionKey];
        
        
    }
    
    return rootVc;

}

@end
