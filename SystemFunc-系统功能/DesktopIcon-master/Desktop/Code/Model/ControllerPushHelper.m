//
//  ControllerPushHelper.m
//  Desktop
//
//  Created by 罗泰 on 2018/11/20.
//  Copyright © 2018 chenwang. All rights reserved.
//

#import "ControllerPushHelper.h"
#import "Module.h"
#import "NextViewController.h"

@implementation ControllerPushHelper

+ (instancetype)sharedHelper {
    static ControllerPushHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[ControllerPushHelper alloc] init];
    });
    return helper;
}


- (void)pushControllerWithopenURL:(NSURL *)url {
    //    absoluteString: cwdesktop://desktopIconClick/open/jump?iconCode=1&title=%E6%A0%87%E9%A2%98
    //    path: /open/jump
    //    scheme: cwdesktop
    //    query: iconCode=1&title=%E6%A0%87%E9%A2%98
    //    host: desktopIconClick
    //    relativePath: /open/jump
    NSLog(@"absoluteString: %@", url.absoluteString);
    NSLog(@"path: %@", url.path);
    NSLog(@"scheme: %@", url.scheme);
    NSLog(@"query: %@", url.query);
    NSLog(@"host: %@", url.host);
    NSLog(@"relativePath: %@", url.relativePath);
    
    // 解析url 拿到后面的参数
    NSString *queryString = url.query;
    Module *m = [self paramFromString:queryString];
    
    // 先获取当前最上层控制器,判断一下
    UIViewController *topVC = [self GET_TOP_CONTROLLER];
    if ([topVC isKindOfClass:[NextViewController class]])
    {
        NextViewController *nextVC = (NextViewController *)topVC;
        if (nextVC.model.code == m.code)
        {
            // 如果当前需要展示的控制器已经是最上层的控制器,则不用跳转了
            return;
        }
    }
    [self pushwithModel:m];
}


- (void)pushwithModel:(Module *)model {
    NextViewController *nextVC = [[NextViewController alloc] initWithModel:model];
    [[self GET_TOP_CONTROLLER].navigationController pushViewController:nextVC animated:YES];
}


- (Module *)paramFromString:(NSString *)str {
    NSArray *tempArr = [str componentsSeparatedByString:@"&"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    Module *m = [[Module alloc] init];
    for (NSString *s in tempArr)
    {
        NSArray *tArr = [s componentsSeparatedByString:@"="];
        if (tArr.count == 2)
        {
            NSString *value = tArr.lastObject;
            NSLog(@"....前: %@", value);
            value =  [value stringByRemovingPercentEncoding];
            NSLog(@"....后: %@", value);
            [dic setObject:value forKey:tArr.firstObject];
        }
    }
    m.title = dic[@"title"];
    m.code = ((NSString *)dic[@"iconCode"]).integerValue;
    return m;
}


- (UIViewController *)GET_TOP_CONTROLLER {
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = [self traversingVC:rootVC];
    NSLog(@"topVC: %@", topVC);
    return topVC;
}


- (UIViewController *)traversingVC:(UIViewController *)vc {
    if (vc == nil) { return nil; }
    if ([vc isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *navVC = (UINavigationController *)vc;
        return [self traversingVC:navVC.topViewController];
    }
    else if([vc isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tabVC = (UITabBarController *)vc;
        return [self traversingVC:tabVC.selectedViewController];
    }
    else if([vc isKindOfClass:[UIViewController class]])
    {
        if(vc.presentedViewController)
            return [self traversingVC:vc.presentedViewController];
    }
    return vc;
}
@end
