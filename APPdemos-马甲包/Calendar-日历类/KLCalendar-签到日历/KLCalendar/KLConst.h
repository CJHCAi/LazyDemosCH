//
//  KLConst.h
//  KLCalendar
//
//  Created by kai lee on 16/7/26.
//  Copyright © 2016年 kai lee. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#define KLog(...) NSLog(__VA_ARGS__)
#else
#define KLog(...)
#endif

#define kUISCREENWIDTH  [UIScreen mainScreen].bounds.size.width     // 屏幕高度
#define kUISCREENHEIGHT [UIScreen mainScreen].bounds.size.height    // 屏幕宽度
#define WEAKSELF typeof(self) __weak weakSelf = self; // 弱引用

extern NSString *const Monday;
extern NSString *const Tuesday;
extern NSString *const Wednesday;
extern NSString *const Thursday;
extern NSString *const Friday;
extern NSString *const Saturday;
extern NSString *const Sunday;