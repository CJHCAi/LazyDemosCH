//
//  HK_TextLoopView.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/4/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_TextLoopView.h"
#import "XBTextLoopView.h"
#define self_H 40
#define leftB_Left 20
#define leftB_H 12
#define leftB_W 16
#define LoopView_W kScreenWidth-100


@interface HK_TextLoopView ()
{
    UIButton *leftB;
}
@end

@implementation HK_TextLoopView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        [self addView];
    }
    return self;
}

-(void)addView
{
    leftB= [UIButton new];
    leftB.backgroundColor = [UIColor clearColor];
    [leftB setTitle:@"" forState:UIControlStateNormal];
    [leftB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftB addTarget:self action:@selector(gotoLeftView) forControlEvents:UIControlEventTouchUpInside];
    [leftB setBackgroundImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [leftB setBackgroundImage:[UIImage imageNamed:@"search"] forState:UIControlStateHighlighted];
    leftB.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    [leftB.layer setCornerRadius:0];
    leftB.titleLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:leftB];
    [leftB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset((self_H-leftB_H)/2);
        make.left.equalTo(self).with.offset(leftB_Left);
        make.size.mas_equalTo(CGSizeMake(leftB_W,leftB_H));
    }];
    
    
    XBTextLoopView *loopView = [XBTextLoopView textLoopViewWith:@[@"我是跑马灯😆1", @"我是跑马灯😆2", @"我是跑马灯😆3"] loopInterval:2.0 initWithFrame:CGRectMake(50, 10,LoopView_W , 20) selectBlock:^(NSString *selectString, NSInteger index) {
        DLog(@"%@===index%ld", selectString, index);
    }];
    
    [self addSubview:loopView];
}
@end
