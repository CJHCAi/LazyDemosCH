//
//  SelectView.m
//  StudyDrive
//
//  Created by apple on 15-7-12.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SelectView.h"

@implementation SelectView
{
    UIButton * _buttton;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame andBtn:(UIButton *)btn{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        _buttton=btn;
        [self creatBtn];
    }
    return self;
}
-(void)creatBtn{
    for (int i=0; i<4; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame=CGRectMake(self.frame.size.width/4*i+self.frame.size.width/4/2-30,self.frame.size.height-80, 60, 60);
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",i+1]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha=0;
    }];
}

-(void)click:(UIButton *)btn{
    [_buttton setImage:[btn backgroundImageForState:UIControlStateNormal]forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha=0;
    }];
}

@end
