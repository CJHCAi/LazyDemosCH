//
//  ScreenAdaptation.h
//  FIngerBusiness
//
//  Created by Chrissy on 16/3/19.
//  Copyright © 2016年 WYL_Group. All rights reserved.
//

#ifndef ScreenAdaptation_h
#define ScreenAdaptation_h

#import <UIKit/UIKit.h>
#import "Custom.h"
/**
 将IPHONE_WIDTH改为设计图纸的宽度
 在使用的时候直接使用BQAdaptationFrame函数
 若通过CGRectGetMaxX(firstView.frame)获取视图坐标
 需判断该视图是否已做过适配，若做过适配需要除以AdaptationWidth()
 还原为其设计图上的坐标位置
 */

#define IPHONE_WIDTH 720


static inline CGFloat AdaptationWidth() {
    return Screen_width / IPHONE_WIDTH;
}

static inline CGSize AdaptationSize(CGFloat width, CGFloat height) {
    CGFloat newWidth = width * AdaptationWidth();
    CGFloat newHeight = height * AdaptationWidth();

    CGSize newSize = CGSizeMake(newWidth, newHeight);
    
    return newSize;
}

static inline CGPoint AdaptationCenter(CGFloat x, CGFloat y) {
    CGFloat newX = x * AdaptationWidth();
    CGFloat newY = y * AdaptationWidth();
    CGPoint point = CGPointMake(newX, newY);
    return point;
}

static inline CGRect AdaptationFrame(CGFloat x,CGFloat y, CGFloat width,CGFloat height)  {
    CGFloat newX = x * AdaptationWidth();
    CGFloat newY = y * AdaptationWidth();
    CGFloat newWidth = width * AdaptationWidth();
    CGFloat newHeight = height * AdaptationWidth();
    CGRect rect = CGRectMake(newX, newY, newWidth, newHeight);
    return rect;
}

#endif /* ScreenAdaptation_h */
