//
//  HKCicleProductTool.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/30.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCicleProductTool.h"

@interface HKCicleProductTool ()
//顶部线
@property (nonatomic, strong)UIView * topLine;

@property (nonatomic, strong)UIImageView *iconViews;
//聊天
@property (nonatomic, strong)UIButton *severBtn;
//中线
@property (nonatomic, strong)UIView *centerLine;
//进入购物车
@property (nonatomic, strong)UIButton *saveBtn;
//加入购物车
@property (nonatomic, strong)UIButton *supllyBtn;
//购物车数量
@property (nonatomic, strong)UILabel *numLabel;
//聊天视图
@property (nonatomic, strong)UIImageView *chatView;
@end

@implementation HKCicleProductTool
-(instancetype)initWithFrame:(CGRect)frame {
    if (self =[super initWithFrame:frame]) {
        self.backgroundColor =[UIColor whiteColor];
        [self addSubview:self.topLine];
        [self addSubview:self.iconViews];
        [self addSubview:self.chatView];
        [self addSubview:self.severBtn];
        [self addSubview:self.centerLine];
        [self addSubview:self.saveBtn];
        [self addSubview:self.numLabel];
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

-(UIImageView *)iconViews {
    if (!_iconViews) {
        _iconViews =[[UIImageView alloc] initWithFrame:CGRectMake(25/2,25/2,25,25)];
        _iconViews.image =kPlaceholderHeadImage;
        _iconViews.layer.cornerRadius =25/2;
        _iconViews.layer.masksToBounds =YES;
    }
    return _iconViews;
}
//聊天
-(UIButton *)severBtn {
    if (!_severBtn) {
        _severBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _severBtn.frame = CGRectMake(0,CGRectGetMaxY(self.topLine.frame),50,49);
        [_severBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _severBtn.tag = 100;
    }
    return _severBtn;
}

-(UIImageView *)chatView {
    if (!_chatView) {
        _chatView =[[UIImageView alloc] initWithFrame:CGRectMake(30,27,12,10)];
        _chatView.image =[UIImage imageNamed:@"talkkfu"];
    }
    return _chatView;
}
-(UIView *)centerLine {
    if (!_centerLine) {
        _centerLine =[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.severBtn.frame),CGRectGetMinY(self.severBtn.frame),1,CGRectGetHeight(self.severBtn.frame))];
        _centerLine.backgroundColor = RGB(226,226,226);
    }
    return _centerLine;
}
-(UIButton *)saveBtn {
    if (!_saveBtn) {
        _saveBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _saveBtn.frame = CGRectMake(CGRectGetMaxX(self.centerLine.frame),CGRectGetMinY(self.centerLine.frame),CGRectGetWidth(self.severBtn.frame),CGRectGetHeight(self.severBtn.frame));
        [_saveBtn setImage:[UIImage imageNamed:@"xq_gwc"] forState:UIControlStateNormal];
        [_saveBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _saveBtn.tag = 200;
    }
    return _saveBtn;
}

-(UILabel *)numLabel
{
    if (!_numLabel) {
        _numLabel =[[UILabel alloc] initWithFrame:CGRectMake(80,10,16,16)];
        [AppUtils getConfigueLabel:_numLabel font:PingFangSCRegular9 aliment:NSTextAlignmentCenter textcolor:[UIColor whiteColor] text:@""];
        _numLabel.layer.cornerRadius =8;
        _numLabel.layer.masksToBounds =YES;
        _numLabel.backgroundColor = keyColor;
    }
    return _numLabel;
}
-(UIButton *)supllyBtn {
    if (!_supllyBtn) {
        _supllyBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _supllyBtn.frame = CGRectMake(CGRectGetMaxX(self.saveBtn.frame),CGRectGetMinY(self.saveBtn.frame),kScreenWidth-101,CGRectGetHeight(self.saveBtn.frame));
        _supllyBtn.backgroundColor = keyColor;
        [AppUtils getButton:_supllyBtn font:BoldFont16 titleColor:[UIColor whiteColor] title:@"加入购物车"];
        [_supllyBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _supllyBtn.tag = 300;
    }
    return _supllyBtn;
}
-(void)btnClick:(UIButton *)sender {
    if (self.delegete && [self.delegete respondsToSelector:@selector(SeverBtnClick:)]) {
        [self.delegete SeverBtnClick:sender.tag];
    }
}
-(void)setResponse:(HKCicleProductResponse *)response {
    _response =response;
    [AppUtils seImageView:self.iconViews withUrlSting:response.data.user.headImg placeholderImage:kPlaceholderHeadImage]; 
}
-(void)setNum:(NSInteger)num {
    if (num) {
        self.numLabel.hidden = NO;
        self.numLabel.text =[NSString stringWithFormat:@"%zd",num];
    }
}
@end
