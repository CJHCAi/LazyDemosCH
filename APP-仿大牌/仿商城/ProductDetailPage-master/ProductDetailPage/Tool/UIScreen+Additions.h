//
//  UIScreen+Additions.h
//  ZhongHeBao
//
//  Created by yangyang on 2017/9/19.
//  Copyright © 2017年 zhbservice. All rights reserved.
//

#import <UIKit/UIKit.h>

/** iPhone类型 **/
#define UI_IS_IPHONE ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define UI_IS_IPHONE4 (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height < 568.0)
#define UI_IS_IPHONE5 (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0)
#define UI_IS_IPHONE6 (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0)
#define UI_IS_IPHONE6PLUS (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0 || [[UIScreen mainScreen] bounds].size.width == 736.0) // Both orientations
#define UI_IS_IPHONEX (UI_IS_IPHONE && ([UIScreen mainScreen].bounds.size.height == 812.0 || [UIScreen mainScreen].bounds.size.width == 812.0))

@interface UIScreen (Additions)

@property (nonatomic, readonly) CGSize size;
@property (nonatomic, readonly) CGFloat width;
@property (nonatomic, readonly) CGFloat height;

+ (CGRect)bounds;
+ (CGSize)size;
+ (CGFloat)width;
+ (CGFloat)height;

+ (CGFloat)statusBarHeight;
+ (CGFloat)navigationBarHeight;
+ (CGFloat)safeBottomMargin;
+ (CGFloat)tabBarHeight;

// e.g. 640x1136
+ (NSString *)resolution;

@end
