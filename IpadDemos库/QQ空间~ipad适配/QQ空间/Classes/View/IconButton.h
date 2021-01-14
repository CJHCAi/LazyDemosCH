//
//  IconButton.h
//  QQ空间
//
//  Created by xiaomage on 15/8/9.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IconButton : UIButton

// 告知IconButton当前屏幕的方向
- (void)rotateToLandscape:(BOOL)isLandscape;

@end
