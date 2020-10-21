//
//  WebProgressView.m
//  VideoHandle
//
//  Created by JSB - Leidong on 17/7/12.
//  Copyright © 2017年 JSB - leidong. All rights reserved.
//

#import "WebProgressView.h"

@interface WebProgressView ()

@property (nonatomic,assign) CGFloat width;

@end

@implementation WebProgressView
//
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.hidden = YES;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
//
-(void)setLineColor:(UIColor *)lineColor{
    
    _lineColor = lineColor;
    self.backgroundColor = lineColor;
}
//
-(void)setWidth:(CGFloat)width{

    _width = width;
    
    CGRect rect = self.frame;
    rect.size.width = width;
    
    self.frame = rect;
}
//
-(void)startLoadingAnimation{
    
    self.hidden = NO;
    self.width = 0.0;
    
    [UIView animateWithDuration:0.4 animations:^{
        
        self.width = SCREENWIDTH * 0.5;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.4 animations:^{
            
            self.width = SCREENWIDTH * 0.8;
        }];
    }];
}
//
-(void)endLoadingAnimation{
    
    [UIView animateWithDuration:0.4 animations:^{
        
        self.width = SCREENWIDTH;
        
    } completion:^(BOOL finished) {
        
        self.hidden = YES;
    }];
}

@end
