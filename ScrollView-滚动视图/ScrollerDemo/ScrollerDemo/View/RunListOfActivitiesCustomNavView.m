//
//  RunListOfActivitiesCustomNavView.m
//  SportChina
//
//  Created by 磊磊 on 2017/6/27.
//  Copyright © 2017年 Beijing Sino Dance Culture Media Co.,Ltd. All rights reserved.
//

#import "RunListOfActivitiesCustomNavView.h"

@implementation RunListOfActivitiesCustomNavView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self creatUI];
    }
    return self;
}
- (void)creatUI
{
    self.backView = [UIView new];
    self.backView.frame = CGRectMake(0, 0, LFScreenW, 64);
    self.backView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.backView];
    /**左边**/
    self.leftView = [UIView new];
    self.leftView.frame = CGRectMake(0, 0, 64, 64);
    self.leftView.backgroundColor = [UIColor clearColor];
    self.leftView.userInteractionEnabled = YES;
    UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pressLeft)];
    [self.leftView addGestureRecognizer:leftTap];
    [self addSubview:self.leftView];
    
    self.leftImage = [UIImageView new];
    self.leftImage.frame = CGRectMake(10, 20 + (44 - 20)/2, 20, 20);
    self.leftImage.backgroundColor = [UIColor clearColor];
    self.leftImage.image = [UIImage imageNamed:@"running_b_w"];
    [self.leftView addSubview:self.leftImage];
    /**title**/
    self.labelTitle = [UILabel new];
    self.labelTitle.frame = CGRectMake(64, 20, LFScreenW - 64*2, 44);
    self.labelTitle.textColor = [UIColor clearColor];
    self.labelTitle.backgroundColor = [UIColor clearColor];
    self.labelTitle.font = [UIFont systemFontOfSize:16.0];
    self.labelTitle.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.labelTitle];
    /**右边**/
    self.rightView = [UIView new];
    self.rightView.frame = CGRectMake(LFScreenW - 64, 0, 64, 64);
    self.rightView.backgroundColor = [UIColor clearColor];
    self.rightView.userInteractionEnabled = YES;
    UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pressRight)];
    [self.rightView addGestureRecognizer:rightTap];
    [self addSubview:self.rightView];
    
    self.rightImage = [UIImageView new];
    self.rightImage.frame = CGRectMake(64 - 13 - 18, 20 + (44 - 20)/2, 18, 18);
    self.rightImage.backgroundColor = [UIColor clearColor];
    self.rightImage.image = [UIImage imageNamed:@"running_s_w"];
    [self.rightView addSubview:self.rightImage];
    
    self.lineView = [UIView new];
    self.lineView.frame = CGRectMake(0, 63.5, LFScreenW, 0.5);
    self.lineView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.lineView];
}
- (void)pressLeft
{
    if (self.clickBlock)
    {
        self.clickBlock(@"0");
    }
}
- (void)pressRight
{
    if (self.clickBlock)
    {
        self.clickBlock(@"1");
    }
}
@end
