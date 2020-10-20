//
//  JDPopView.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/4/5.
//  Copyright © 2017年 wangjundong. All rights reserved.
//


#import "JDPopView.h"

@implementation JDPopView
{
    UIView *backView;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor =[UIColor whiteColor];
        self.frame =CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDHT, SCREEN_HEIGHT/2);
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap2)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)showWithBlock:(callBackBlock)block
{
    _callblock =block;
    UIWindow *window =[UIApplication sharedApplication].keyWindow;
    backView =[JDUtils createViewWithFrame:window.frame];
    backView.backgroundColor =JDRGBColor(0, 0, 0, 0.5);
    backView.backgroundColor=[UIColor orangeColor];
//    backView.alpha = 0.5;
    [self addSubview:backView];

   [window addSubview:self];
  
    
    [UIView animateWithDuration:0.25 delay:0  options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.originY =SCREEN_HEIGHT/2;
        backView.alpha = 1;
    } completion:^(BOOL finished) {
        
    } ];
    
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [backView addGestureRecognizer:tap];
    
    
    
}

- (void)tap2
{
    _callblock(@"点击弹出视图区域");
}

- (void)tap
{
    DLog(@"取消弹出视图");
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.originY =SCREEN_HEIGHT;
        backView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [backView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

@end
