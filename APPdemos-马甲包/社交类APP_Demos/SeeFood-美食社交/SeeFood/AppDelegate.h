//
//  AppDelegate.h
//  XMPP
//
//  Created by 纪洪波 on 15/11/19.
//  Copyright © 2015年 纪洪波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) BOOL isRotation;
@property (strong, nonatomic) NSString *logUsername;
@property (nonatomic, assign) BOOL islogged;
@end

