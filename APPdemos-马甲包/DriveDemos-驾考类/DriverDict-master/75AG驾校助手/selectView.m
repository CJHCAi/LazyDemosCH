//
//  selectView.m
//  75AG驾校助手
//
//  Created by again on 16/3/27.
//  Copyright © 2016年 again. All rights reserved.
//

#import "selectView.h"

@interface selectView()
@property (weak,nonatomic) UIButton *btn;
@end

@implementation selectView

- (instancetype)initWithFrame:(CGRect)frame andBtn:(UIButton *)btn
{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        self.btn = btn;
        [self createBtn];
    }
    return self;
}

- (void)createBtn
{
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(self.frame.size.width/4 * i + self.frame.size.width/4/2-30, self.frame.size.height - 80, 60, 60);
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png", i + 1]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    }];
}

- (void)click:(UIButton *)btn
{
    [self.btn setImage:[btn backgroundImageForState:UIControlStateNormal] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    }];
}
@end
