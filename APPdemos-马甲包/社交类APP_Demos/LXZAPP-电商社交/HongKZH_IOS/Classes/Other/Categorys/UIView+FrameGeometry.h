//
//  UIView+FrameGeometry.h
//  XiYou_IOS
//
//  Created by regan on 15/11/19.
//  Copyright © 2015年 regan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

CGPoint CGRectGetCenter(CGRect rect);
CGRect  CGRectMoveToCenter(CGRect rect, CGPoint center);

@interface UIView (ViewFrameGeometry)
@property CGPoint origin;     //设置x,y轴坐标
@property CGSize size;        //宽，高

@property (readonly) CGPoint bottomLeft;   //view的底左边界
@property (readonly) CGPoint bottomRight;  //view的底右边界
@property (readonly) CGPoint topRight;     //view上右边界

@property CGFloat height;     //高
@property CGFloat width;      //宽

@property CGFloat top;        //顶部y
@property CGFloat left;       //左部x

@property CGFloat bottom;     //底下y
@property CGFloat right;      //右边x

- (void) moveBy: (CGPoint) delta;
- (void) scaleBy: (CGFloat) scaleFactor;
- (void) fitInSize: (CGSize) aSize;

@end
@interface UIView (Uitls)

- (void)setBorderWidth:(CGFloat)with;

- (CGFloat)borderWidth;

- (void)setBorderColor:(UIColor *)color;

- (UIColor *)borderColor;

- (CGFloat)x;

- (CGFloat)y;

- (CGFloat)width;

- (CGFloat)height;

- (CGPoint)origin;

- (CGSize)size;

- (void)setX:(CGFloat)x;

- (void)setY:(CGFloat)y;

- (void)setWidth:(CGFloat)width;

- (void)setHeight:(CGFloat)height;

- (void)setOrigin:(CGPoint)origin;

- (void)setSize:(CGSize)size;

- (CGFloat)left;

- (CGFloat)right;

- (CGFloat)top;

- (CGFloat)bottom;
@end

@interface UIView(FindFirstResponder)
- (UIView *)findFirstResponder;
@end
