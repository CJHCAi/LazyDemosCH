//
//  HKCicleHeadView.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/30.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCicleHeadView.h"

@interface HKCicleHeadView ()
@property (nonatomic, strong)UIButton *backBtn;
@property (nonatomic, strong)UIButton *shareBtn;
@end

@implementation HKCicleHeadView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self =[super initWithFrame:frame]) {
        self.backgroundColor =[UIColor clearColor];
        [self addSubview:self.backBtn
         ];
        [self addSubview:self.shareBtn];
    }
    return self;
}
-(UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(15,15,40,40);
        [_backBtn setImage:[UIImage imageNamed:@"sp_fh"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
        _backBtn.tag = 100;
    }
    return _backBtn;
}
-(UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _shareBtn.frame = CGRectMake(kScreenWidth-15-40,CGRectGetMinY(self.backBtn.frame),40,40);
        [_shareBtn setImage:[UIImage imageNamed:@"sp_jl"] forState:UIControlStateNormal];
        [_shareBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
        _shareBtn.tag =200;
    }
    return _shareBtn;
}
-(void)backClick:(UIButton *)sender {
    if (self.delegete && [self.delegete respondsToSelector:@selector(ClickSenderWithIndex:)]) {
        [self.delegete ClickSenderWithIndex:sender.tag];
    }
}
@end
