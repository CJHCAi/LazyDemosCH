//
//  HKSlider.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/11/5.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSlider.h"

@implementation HKSlider
- (CGRect)trackRectForBounds:(CGRect)bounds {
    bounds.size.height=5;
    self.layer.cornerRadius = 2.5;
    bounds.origin.y =  2.5;
    return bounds;
}


@end
