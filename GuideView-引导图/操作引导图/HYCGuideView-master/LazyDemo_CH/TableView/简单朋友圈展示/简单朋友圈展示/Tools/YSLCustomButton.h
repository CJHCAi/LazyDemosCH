//
//  YSLCustomButton.h
//  YSLFramework
//
//  Created by beyond on 2017/12/28.
//  Copyright © 2017年 beyond. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger) {
    YSLCustomButtonImageTop    = 0 , //图片在上边
    YSLCustomButtonImageLeft   = 1 , //图片在左边
    YSLCustomButtonImageBottom = 2 , //图片在下边
    YSLCustomButtonImageRight  = 3   //图片在右边
}YSLCustomButtonType;

@interface YSLCustomButton : UIButton

/** 图片和文字间距 默认10px*/
@property (nonatomic , assign) CGFloat ysl_spacing;

/** 按钮类型 默认YSLCustomButtonImageTop 图片在上边*/
@property (nonatomic , assign) YSLCustomButtonType ysl_buttonType;


@end
