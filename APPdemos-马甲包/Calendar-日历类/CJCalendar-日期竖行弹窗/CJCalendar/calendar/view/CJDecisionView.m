//
//  CJDecisionView.m
//  CJCalendar
//
//  Created by chjsun on 16/5/25.
//  Copyright © 2016年 chjsun. All rights reserved.
//

#import "CJDecisionView.h"

#define CJColor(r, g, b) ([UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1])

@implementation CJDecisionView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.textColor = CJColor(71, 55, 169);
        self.selectColor = CJColor(30, 25, 70);
    }
    return self;
}


-(void) generateDecision{
    CGFloat width = self.frame.size.width/4;
    CGFloat height = self.frame.size.height;
    
    // 返回当前
    CGRect nowRect = CGRectMake(0, 0, width, height);
    [self addNow:nowRect];
    // 取消
    CGRect cancelRect = CGRectMake(width * 2, 0, width, height);
    [self addCancel:cancelRect];
    // 确定
    CGRect actionRect = CGRectMake(width * 3, 0, width, height);
    [self addAction:actionRect];

}
// 返回当前
-(void) addNow:(CGRect)rect{
    
    UIButton *now = [[UIButton alloc] initWithFrame:rect];
    [now setTitle:@"今日" forState:UIControlStateNormal];
    now.titleLabel.font = [UIFont systemFontOfSize:15];
    [now setTitleColor:self.textColor forState:UIControlStateNormal];
    [now setTitleColor:self.selectColor forState:UIControlStateHighlighted];
    
    [now addTarget:self action:@selector(didNow:) forControlEvents:UIControlEventTouchDown];
    
    [self addSubview:now];
}
// 返回按钮点击事件
-(void) didNow:(UIButton *)button{

    if ([self.delegate respondsToSelector:@selector(DecisionDidSelectNow:)]) {
        [self.delegate DecisionDidSelectNow:self];
    }
    
}


// 取消
-(void) addCancel:(CGRect)rect{
    
    UIButton *cancel = [[UIButton alloc] initWithFrame:rect];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:self.textColor forState:UIControlStateNormal];
    [cancel setTitleColor:self.selectColor forState:UIControlStateHighlighted];
    cancel.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [cancel addTarget:self action:@selector(didCancel:) forControlEvents:UIControlEventTouchDown];
    
    [self addSubview:cancel];
}

// 取消按钮点击事件
-(void) didCancel:(UIButton *)button{
    
    if ([self.delegate respondsToSelector:@selector(DecisionDidSelectCancel:)]) {
        [self.delegate DecisionDidSelectCancel:self];
    }
}


// 确定
-(void) addAction:(CGRect)rect{
    
    UIButton *action = [[UIButton alloc] initWithFrame:rect];
    [action setTitle:@"确定" forState:UIControlStateNormal];
    [action setTitleColor:self.textColor forState:UIControlStateNormal];
    [action setTitleColor:self.selectColor forState:UIControlStateHighlighted];
    action.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [action addTarget:self action:@selector(didAction:) forControlEvents:UIControlEventTouchDown];
    
    [self addSubview:action];
}

// 确定按钮点击事件
-(void) didAction:(UIButton *)button{

    if ([self.delegate respondsToSelector:@selector(DecisionDidSelectAction:)]) {
        [self.delegate DecisionDidSelectAction:self];
    }
}


@end
