//
//  HKCollageInfoToolBar.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/3.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCollageInfoToolBar.h"

@interface HKCollageInfoToolBar ()
//顶部线
@property (nonatomic, strong)UIView * topLine;
//呼叫客服
@property (nonatomic, strong)UIButton *severBtn;
//中线
@property (nonatomic, strong)UIView *centerLine;
//收藏
@property (nonatomic, strong)UIButton *saveBtn;
//发起拼单
@property (nonatomic, strong)UIButton *supllyBtn;

/*********折扣劵底部Bar*********/
@property (nonatomic, strong)UILabel *payLabel;
@property (nonatomic, strong)UIImageView * iconV;
@property (nonatomic, strong)UILabel *countLabel;

@end

@implementation HKCollageInfoToolBar

-(instancetype)initWithFrame:(CGRect)frame {
    if (self =[super initWithFrame:frame]) {
        self.backgroundColor =[UIColor whiteColor];
        [self addSubview:self.topLine];
        [self addSubview:self.severBtn];
        [self addSubview:self.centerLine];
        [self addSubview:self.saveBtn];
        [self addSubview:self.supllyBtn];
    }
    return self;
}
-(UIView *)topLine {
    if (!_topLine) {
        _topLine =[[UIView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,1)];
        _topLine.backgroundColor = RGB(226,226,226);
    }
    return _topLine;
}
-(UIButton *)severBtn {
    if (!_severBtn) {
        _severBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _severBtn.frame = CGRectMake(0,CGRectGetMaxY(self.topLine.frame),96,49);
        [_severBtn setImage:[UIImage imageNamed:@"ptxq_kf"] forState:UIControlStateNormal];
        [_severBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _severBtn.tag = 100;
        
        _severBtn.hidden = YES;
    }
    return _severBtn;
}
-(UIView *)centerLine {
    if (!_centerLine) {
        _centerLine =[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.severBtn.frame),CGRectGetMinY(self.severBtn.frame),1,CGRectGetHeight(self.severBtn.frame))];
        _centerLine.backgroundColor = RGB(226,226,226);
        _centerLine.hidden = YES;
    }
    return _centerLine;
}
-(UIButton *)saveBtn {
    if (!_saveBtn) {
        _saveBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _saveBtn.frame = CGRectMake(CGRectGetMaxX(self.centerLine.frame),CGRectGetMinY(self.centerLine.frame),95,CGRectGetHeight(self.severBtn.frame));
        [_saveBtn setImage:[UIImage imageNamed:@"ptzx_sc"] forState:UIControlStateNormal];
        [_saveBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _saveBtn.tag = 200;
        _saveBtn.hidden = YES;
    }
    return _saveBtn;
}                
-(UIButton *)supllyBtn {
    if (!_supllyBtn) {
        _supllyBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _supllyBtn.frame = CGRectMake(CGRectGetMaxX(self.saveBtn.frame),CGRectGetMinY(self.saveBtn.frame),kScreenWidth-192,CGRectGetHeight(self.saveBtn.frame));
        _supllyBtn.backgroundColor = keyColor;
        [AppUtils getButton:_supllyBtn font:PingFangSCRegular16 titleColor:[UIColor whiteColor] title:@"发起拼单"];
        [_supllyBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _supllyBtn.tag = 300;
    }
    return _supllyBtn;
}
-(void)RefreshToolBarUI {
    self.severBtn.hidden = YES;
    self.saveBtn.hidden = YES;
    self.centerLine.hidden =YES;
    [self.supllyBtn setTitle:@"立即抢购" forState:UIControlStateNormal];
    [self addSubview:self.payLabel];
    [self addSubview:self.iconV];
    [self addSubview:self.countLabel];
}
-(UILabel *)payLabel {
    if (!_payLabel) {
        _payLabel =[[UILabel alloc] initWithFrame:CGRectMake(15,18,42,14)];
        [AppUtils getConfigueLabel:_payLabel font:PingFangSCRegular14 aliment:NSTextAlignmentLeft textcolor:RGB(102,102,102) text:@"应付:"];
    }
    return _payLabel;
}

-(UIImageView *)iconV {
    if (!_iconV) {
        _iconV =[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.payLabel.frame),17.5,15,15)];
        _iconV.image =[UIImage imageNamed:@"sp_lb"];
    }
    return _iconV;
}
-(UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconV.frame)+5,CGRectGetMinY(self.payLabel.frame),200,CGRectGetHeight(self.payLabel.frame))];
        [AppUtils getConfigueLabel:_countLabel font:[UIFont boldSystemFontOfSize:17] aliment:NSTextAlignmentLeft textcolor:keyColor text:@""];
    }
    return _countLabel;
}
-(void)setCountLabelWithNumber:(NSInteger)number {
    self.countLabel.text =[NSString stringWithFormat:@"%zd",number];
}

-(void)btnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(toolBlock:)]) {
        [self.delegate toolBlock:sender.tag];
    }
}
@end
