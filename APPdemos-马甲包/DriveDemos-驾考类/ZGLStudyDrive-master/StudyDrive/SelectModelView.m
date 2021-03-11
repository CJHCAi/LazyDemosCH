//
//  SelectModelView.m
//  StudyDrive
//
//  Created by zgl on 16/1/23.
//  Copyright © 2016年 sj. All rights reserved.
//

#import "SelectModelView.h"

@implementation SelectModelView
{
    SelectTouch block;
}

-(SelectModelView *)initWithFrame:(CGRect)frame addTouch:(SelectTouch)touch
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
        block = touch;
        _model = testModel;
    }
    return self;
}

-(void)creatUI
{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    NSArray * array = @[@"答题模式",@"背题模式"];
    for (int i=0; i<2; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(self.frame.size.width/2-50, self.frame.size.height/2-200+i*130, 100, 100);
        btn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        btn.tag = 401+i;
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 8;
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 60, 60)];
        image.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d11q.png",i+1]];
        [btn addSubview:image];
        
        UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 75, 80, 20)];
        lab.font = [UIFont systemFontOfSize:15];
        lab.textColor = [UIColor whiteColor];
        lab.textAlignment  = NSTextAlignmentCenter;
        lab.text = array[i];
        [btn addSubview:lab];
        
        [self addSubview:btn];
        
    }
}

-(void)click:(UIButton *)btn
{
    if (btn.tag==401) {
        _model = testModel;
    }else{
        _model = lookingModel;
    }
    block(_model);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    }];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
