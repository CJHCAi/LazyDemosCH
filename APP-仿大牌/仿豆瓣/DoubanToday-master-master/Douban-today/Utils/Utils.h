//
//  Utils.h
//  Douban-today
//
//  Created by dzw on 2018/10/26.
//  Copyright © 2018 dzw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/utsname.h>
#import <UIKit/UIKit.h>


@interface Utils : NSObject

#pragma mark -- global define

#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height
#define SCREEN_BOUNDS   [UIScreen mainScreen].bounds
#define SCREEN_RATIO(x) (x*(SCREEN_WIDTH/375.0))

#define LINE_WIDTH 0.5

#define INDUSTRY_RATIO 0.34

#define IPHONE_X ([[Utils iphoneModels] isEqualToString:@"iPhone X"] || [[UIScreen mainScreen] bounds].size.height == 812)

#define VIEW_BORDER_RADIUS(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

//字符串是否为空
#define IsStrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref)isEqualToString:@""]))
//数组是否为空
#define IsArrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref) count] == 0))

//log
#ifdef DEBUG
# define NSLog(...) NSLog(__VA_ARGS__)
#else
# define NSLog(...) {}
#endif

#pragma mark -- util method

+ (NSString*)iphoneModels;

+ (CGSize)withString:(NSString *)string font:(UIFont *)font;

+ (CGSize)withString:(NSString *)string font:(UIFont *)font ViewWidth:(float)Width;

+ (UIColor *) colorWithHexString: (NSString *)color;

@end
