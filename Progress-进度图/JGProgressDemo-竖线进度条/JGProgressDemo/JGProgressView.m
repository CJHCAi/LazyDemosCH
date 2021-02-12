//
//  JGProgressView.m
//  JGProgressDemo
//
//  Created by 郭军 on 2017/9/1.
//  Copyright © 2017年 ZJBL. All rights reserved.
//

#import "JGProgressView.h"

#define KProgressPadding 5.0f
#define KProgressLineWidth 3.0f



@implementation JGProgressView



- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        
       
    }
    
    return self;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    CGFloat maxWidth = self.bounds.size.width;
    CGFloat selfHeigth = self.bounds.size.height;
    uint32_t selfH = floor(selfHeigth);
    
    int Count = maxWidth / (KProgressPadding + KProgressLineWidth);
    int LCount = maxWidth * progress / (KProgressPadding + KProgressLineWidth);

    for (int i = 0 ; i < Count; i++) {
        NSInteger lineH = arc4random_uniform(selfH)+2;

        CGFloat X = i * (KProgressLineWidth + KProgressPadding);
        UIView *Line = [[UIView alloc] initWithFrame:CGRectMake(X, (selfHeigth-lineH)/2, KProgressLineWidth, lineH)];
        Line.backgroundColor = (i < LCount) ? [UIColor blueColor] : [UIColor lightGrayColor];
//        Line.layer.anchorPoint = CGPointMake(0, 0.5);
        [self addSubview:Line];
        
    }
}



@end
