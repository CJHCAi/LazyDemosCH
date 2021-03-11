//
//  SelectView.m
//  DriverLicense_01
//
//  Created by 付小宁 on 16/2/3.
//  Copyright © 2016年 Maizi. All rights reserved.
//

#import "SelectView.h"

@implementation SelectView
////加入成员变量用来接受Button
{
    UIButton *_button;
}
//实现车型选择界面
//初始化界面
-(instancetype)initWithFrame:(CGRect)frame andBtn:(UIButton *)btn
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        _button = btn;
        [self creatBtn];
    }
    return self;
}

//创建按钮初始化
-(void)creatBtn{
    for (int i=0; i<4; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(self.frame.size.width/4*i + self.frame.size.width/4/2 - 30, self.frame.size.height -60, 60, 60);
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",i +1]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    
}
//点击界面时候不显示
-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 0;
    }];
}

//按钮事件
-(void)click:(UIButton *)btn
{
    //根据button的状态来获取不同的背景图片
    
    [_button setImage:[btn backgroundImageForState: UIControlStateNormal] forState:(UIControlStateNormal)];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 0;
    }];
    
}

@end

