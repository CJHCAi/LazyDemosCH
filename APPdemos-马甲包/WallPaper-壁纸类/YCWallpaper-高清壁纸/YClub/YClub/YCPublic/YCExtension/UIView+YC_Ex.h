//
//  UIView+YC_Ex.h
//  YClub
//
//  Created by 岳鹏飞 on 2017/4/29.
//  Copyright © 2017年 岳鹏飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YC_Ex)

- (void)setTop:(CGFloat)top;
- (CGFloat)top;

- (void)setLeft:(CGFloat)left;
- (CGFloat)left;

- (void)setBottom:(CGFloat)bottom;
- (CGFloat)bottom;

- (void)setRight:(CGFloat)right;
- (CGFloat)right;

- (void)setWidth:(CGFloat)width;
- (CGFloat)width;

- (void)setHeight:(CGFloat)height;
- (CGFloat)height;

- (void)setCenterX:(CGFloat)centerX;
- (CGFloat)centerX;

- (void)setCenterY:(CGFloat)centerY;
- (CGFloat)centerY;

-(void)setSize:(CGSize)size;
- (CGSize)size;

- (void)setOrigin:(CGPoint)origin;
- (CGPoint)origin;

@end
