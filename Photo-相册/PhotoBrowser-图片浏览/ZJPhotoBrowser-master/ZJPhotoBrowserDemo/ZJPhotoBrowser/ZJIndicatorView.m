//
//  ZJIndicatorView.m
//  ZJPhotoBrowserDemo
//
//  Created by 陈志健 on 2017/4/13.
//  Copyright © 2017年 chenzhijian. All rights reserved.
//

#import "ZJIndicatorView.h"

@implementation ZJIndicatorView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)indicatorShowInView:(UIView *)view {
    
    ZJIndicatorView *indicatorView = [[ZJIndicatorView alloc] initWithFrame:CGRectMake( 0, 0, kIndicatorViewWidth, kIndicatorViewWidth)];
    
    if (indicatorView ) {
        
        indicatorView.backgroundColor = kIndicatorViewBackgroundColor;
        indicatorView.clipsToBounds = YES;
        indicatorView.status = IndicatorViewStatusLoading;
        indicatorView.layer.cornerRadius = kIndicatorViewWidth / 2.0;
        indicatorView.center = CGPointMake(view.frame.size.width/2.0, view.frame.size.height/2.0);
        indicatorView.viewMode = IndicatorViewModeLoopDiagram;//圆
        [view addSubview:indicatorView];
    }
    return indicatorView;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setNeedsDisplay];
    if (progress >= 1) {
        [self removeFromSuperview];
    }
}

- (void)hideIndicatorViewWithSucceed:(BOOL)succeed {

    if (succeed) {
        self.status = IndicatorViewStatusSuccess;
        [self removeFromSuperview];
    }else {
        self.status = IndicatorViewStatusFalid;
        [self setNeedsDisplay];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, kIndicatorViewWidth)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"原图加载失败";
        label.font = [UIFont systemFontOfSize:14];
        self.bounds = label.frame;
        label.textColor = [UIColor whiteColor];
        label.center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
        self.layer.cornerRadius = 5;
        [self addSubview:label];
        
        [UIView animateWithDuration:2 animations:^{
            
            self.alpha = 0;
            
        } completion:^(BOOL finished) {
            
            [self removeFromSuperview];
        }];
    }
}


- (void)drawRect:(CGRect)rect {
    
    if (self.status != IndicatorViewStatusLoading) {
        
        return;
    }
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat xCenter = rect.size.width * 0.5;
    CGFloat yCenter = rect.size.height * 0.5;
    [[UIColor whiteColor] set];
    
    switch (self.viewMode) {
        case IndicatorViewModePieDiagram:
        {
            CGFloat radius = MIN(rect.size.width * 0.5, rect.size.height * 0.5) - kIndicatorViewItemMargin;
            
            
            CGFloat w = radius * 2 + kIndicatorViewItemMargin;
            CGFloat h = w;
            CGFloat x = (rect.size.width - w) * 0.5;
            CGFloat y = (rect.size.height - h) * 0.5;
            CGContextAddEllipseInRect(ctx, CGRectMake(x, y, w, h));
            CGContextFillPath(ctx);
            
            [kIndicatorViewBackgroundColor set];
            CGContextMoveToPoint(ctx, xCenter, yCenter);
            CGContextAddLineToPoint(ctx, xCenter, 0);
            CGFloat to = - M_PI * 0.5 + self.progress * M_PI * 2 + 0.001; // 初始值
            CGContextAddArc(ctx, xCenter, yCenter, radius, - M_PI * 0.5, to, 1);
            CGContextClosePath(ctx);
            
            CGContextFillPath(ctx);
        }
            break;
            
        default:
        {
            CGContextSetLineWidth(ctx, 4);
            CGContextSetLineCap(ctx, kCGLineCapRound);
            CGFloat to = - M_PI * 0.5 + self.progress * M_PI * 2 + 0.05; // 初始值0.05
            CGFloat radius = MIN(rect.size.width, rect.size.height) * 0.5 - kIndicatorViewItemMargin;
            CGContextAddArc(ctx, xCenter, yCenter, radius, - M_PI * 0.5, to, 0);
            CGContextStrokePath(ctx);
        }
            break;
    }
}

@end
