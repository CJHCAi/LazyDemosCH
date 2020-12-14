//
//  UIView+Helper.h
//  DingDing
//
//  Created by Dry on 16/5/30.
//  Copyright © 2016年 Cstorm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DDView)


@property CGFloat origin_x;
@property CGFloat origin_y;

@property CGFloat width;
@property CGFloat height;

@property (readonly) CGFloat toLeftMargin;       //origin_x+width
@property (readonly) CGFloat toTopMargin;        //origin_y+height


@end
