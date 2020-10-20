//
//  UIView+Utils.h
//  MVVM-demo
//
//  Created by shen_gh on 16/4/13.
//  Copyright © 2016年 申冠华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Utils)

//宽度
- (CGFloat)current_w;

//高度
- (CGFloat)current_h;

//当前view.frame的x、y、x+宽、y+高
- (CGFloat)current_x;
- (CGFloat)current_y;
- (CGFloat)current_x_w;
- (CGFloat)current_y_h;

@end
