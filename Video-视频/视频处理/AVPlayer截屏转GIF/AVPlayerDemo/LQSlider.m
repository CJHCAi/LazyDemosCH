//
//  LQSlider.m
//  Progress
//
//  Created by 李强 on 17/2/28.
//  Copyright © 2017年 李强. All rights reserved.
//

#import "LQSlider.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@implementation LQSlider


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //初始化设置
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]init];
        tapRecognizer.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapRecognizer];
        
    }
    return self;
}

- (CGRect)trackRectForBounds:(CGRect)bounds{
    if(self.type == LQSliderBig){
        return CGRectMake(0, 15, 414, 6);
    }else if(self.type == LQSliderMiddle){
        return CGRectMake(0, 0, 414, 4);
    }else{
        return CGRectMake(0, 0, 414, 4);
    }
}
- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value
{
    if(self.type == LQSliderBig){
        rect.origin.x = rect.origin.x - 5;
//        rect.size.width = rect.size.width +15;
        return [super thumbRectForBounds:bounds trackRect:rect value:value];
    }else{
        rect.origin.x = rect.origin.x - 2;
        rect.size.width = rect.size.width - 15;
        return CGRectInset ([super thumbRectForBounds:bounds trackRect:rect value:value], 0 , 0);
    }
}
//扩大UISlider的Thumb的响应范围
- (BOOL) pointInside:(CGPoint)point withEvent:(UIEvent*)event {
    CGRect bounds = self.bounds;
    bounds = CGRectInset(bounds, -30 , -30);
    return CGRectContainsPoint(bounds, point);
}
@end
