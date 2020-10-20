//
//  AppDelegate.h
//  QQLoginDemo
//
//  Created by 张国荣 on 16/6/17.
//  Copyright © 2016年 BateOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QQShareDelegate <NSObject>

-(void)shareSuccssWithQQCode:(NSInteger)code;
@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (weak  , nonatomic) id<QQShareDelegate> qqDelegate;

@end

