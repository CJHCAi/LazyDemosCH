//
//  UITextField+DynamicFontSize.h
//  Created by kcandr on 16/12/14.

#ifndef christmas_UITextField_DynamicFontSize_h
#define christmas_UITextField_DynamicFontSize_h

#import <UIKit/UIKit.h>

@interface UITextField (DynamicFontSize)

- (void)adjustsFontSizeToFillItsContents;
- (void)adjustsFontSizeToFillRect:(CGRect)newBounds;
- (void)adjustsWidthToFillItsContents;

@end

#endif

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
