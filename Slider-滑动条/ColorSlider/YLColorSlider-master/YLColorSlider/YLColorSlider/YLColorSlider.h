//
//  YLColorSlider.h
//  YLColorSlider
//
//  Created by wlx on 17/3/29.
//  Copyright © 2017年 Tim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLColorSlider : UIView
- (instancetype)initWithFrame:(CGRect)frame selectedColorBlock:(void(^)(UIColor *color))colorBlock;
@end
