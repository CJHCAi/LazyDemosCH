//
//  UIView+PPAddition.h
//  amezMall_New
//
//  Created by Liao PanPan on 2017/4/5.
//  Copyright © 2017年 Liao PanPan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (PPAddition)

@property (nonatomic) CGFloat PP_left;        ///< Shortcut for frame.origin.x.
@property (nonatomic) CGFloat PP_top;         ///< Shortcut for frame.origin.y
@property (nonatomic) CGFloat PP_right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic) CGFloat PP_bottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic) CGFloat PP_width;       ///< Shortcut for frame.size.width.
@property (nonatomic) CGFloat PP_height;      ///< Shortcut for frame.size.height.
@property (nonatomic) CGFloat PP_centerX;     ///< Shortcut for center.x
@property (nonatomic) CGFloat PP_centerY;     ///< Shortcut for center.y
@property (nonatomic) CGPoint PP_origin;      ///< Shortcut for frame.origin.
@property (nonatomic) CGSize  PP_size;        ///< Shortcut for frame.size.

@property (nullable, nonatomic, readonly) UIViewController *viewController;



@end
