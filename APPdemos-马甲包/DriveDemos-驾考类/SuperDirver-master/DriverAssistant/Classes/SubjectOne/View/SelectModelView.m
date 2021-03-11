//
//  SelectModelView.m
//  DriverAssistant
//
//  Created by C on 16/3/31.
//  Copyright © 2016年 C. All rights reserved.
//

#import "SelectModelView.h"

@implementation SelectModelView
{
    SelectTouch block;
}
- (SelectModelView *)initWithFrame:(CGRect)frame andTouch:(SelectTouch)touch
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
        block = touch;
    }
    return self;
}
- (void)creatUI{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    NSArray *array = @[@"答题模式",@"背题模式"];
    for (int i = 0; i < 2; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 401+i;
        btn.frame = CGRectMake(self.frame.size.width/2 - 50, self.frame.size.height/2 - 200+i*130, 100, 100);
        btn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        btn.layer.cornerRadius = 8;
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 60, 60)];
        image.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d11q.png",i+1]];
        [btn addSubview:image];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 75, 80, 20)];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = array[i];
        [btn addSubview:label];
        [self addSubview:btn];
    }
}

- (void) click:(UIButton *)btn{
    block(btn);
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    }];

}
@end
