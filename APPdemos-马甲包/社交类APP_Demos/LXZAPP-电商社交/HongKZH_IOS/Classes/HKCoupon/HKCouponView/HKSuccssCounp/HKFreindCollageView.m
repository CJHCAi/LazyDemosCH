//
//  HKFreindCollageView.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKFreindCollageView.h"

@interface HKFreindCollageView ()
@property (nonatomic, strong)UIView *line;
@property (nonatomic, strong)UILabel * titleLabel;
@property (nonatomic, strong)UIImageView * headerView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *tipLabel;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UIButton * goCollageBtn;

@end

@implementation HKFreindCollageView

-(instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame: frame];
    if (self) {
        self.backgroundColor =[UIColor whiteColor];
        [self addSubview:self.line];
        [self addSubview:self.titleLabel];
        [self addSubview:self.headerView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.tipLabel];
        [self addSubview:self.timeLabel];
        [self addSubview:self.goCollageBtn];
    }
    return self;
}
-(UIView *)line {
    if (!_line) {
        _line =[[UIView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,1)];
        _line.backgroundColor = RGB(226,226,226);
    }
    return _line;
}
-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(self.line.frame)+8,kScreenWidth-30,20)];
        [AppUtils getConfigueLabel:_titleLabel font:PingFangSCRegular14 aliment:NSTextAlignmentLeft textcolor:RGB(102,102,102) text:@""];
    }
    return _titleLabel;
}
-(UIImageView *)headerView {
    if (!_headerView) {
        _headerView =[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame),CGRectGetMaxY(self.titleLabel.frame)+15,45,45)];
        _headerView.layer.cornerRadius =45/2;
        _headerView.layer.masksToBounds =YES;
        _headerView.image =[UIImage imageNamed:@"tx_01"];
    }
    return _headerView;
}
-(UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headerView.frame)+10,CGRectGetMinY(self.headerView.frame),120,CGRectGetHeight(self.headerView.frame))];
        [AppUtils getConfigueLabel:_nameLabel font:PingFangSCRegular15 aliment:NSTextAlignmentLeft textcolor:RGB(51,51,51) text:@"Andy"];
    }
    return _nameLabel;
}
-(UIButton *)goCollageBtn {
    if (!_goCollageBtn) {
        _goCollageBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _goCollageBtn.frame = CGRectMake(kScreenWidth-15-68,CGRectGetMinY(self.headerView.frame)+8,68,29);
        [AppUtils getButton:_goCollageBtn font:PingFangSCRegular14 titleColor:[UIColor whiteColor] title:@"去拼单"];
        _goCollageBtn.backgroundColor = keyColor;
        _goCollageBtn.layer.cornerRadius = 5;
        _goCollageBtn.layer.masksToBounds =YES;
        [_goCollageBtn addTarget:self action:@selector(goCollageClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goCollageBtn;
}

-(void)goCollageClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(collageBlock)]) {
        [self.delegate collageBlock];
    }
}

-(UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.goCollageBtn.frame)-10-120,CGRectGetMinY(self.goCollageBtn.frame),120,13)];
        [AppUtils getConfigueLabel:_tipLabel font:PingFangSCRegular13 aliment:NSTextAlignmentRight textcolor:[UIColor colorFromHexString:@"333333"] text:@""];
        NSString * text =@"还差1人拼单";
        NSMutableAttributedString * mutable =[[NSMutableAttributedString alloc] initWithString:text];
        [mutable addAttribute:NSForegroundColorAttributeName value:keyColor range:NSMakeRange(2,2)];
        _tipLabel.attributedText = mutable;
    }
    return _tipLabel;
}

-(UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.tipLabel.frame),CGRectGetMaxY(self.tipLabel.frame)+3,CGRectGetWidth(self.tipLabel.frame),12)];
        [AppUtils getConfigueLabel:_timeLabel font:PingFangSCRegular12 aliment:NSTextAlignmentRight textcolor:RGB(153,153,153) text:@"23:50:46"];
    }
    return _timeLabel;
}
-(void)setResponse:(HKCollageOrderResponse *)response {
    _response = response;
    HKCollageList *list =response.data.list.firstObject;
    NSString * text =[NSString stringWithFormat:@"你的好友%@还差1人拼单就成功啦",list.name];
    NSMutableAttributedString * mutable =[[NSMutableAttributedString alloc] initWithString:text];
    [mutable addAttribute:NSForegroundColorAttributeName value:keyColor range:NSMakeRange(6+list.name.length,2)];
    self.titleLabel.attributedText = mutable;
    [AppUtils seImageView:self.headerView withUrlSting:list.headImg placeholderImage:kPlaceholderImage];
    self.nameLabel.text =list.name;
    NSString *timeStr =[HKCounponTool getConponLastStringWithEndString:response.data.endDate];
    if ([timeStr isEqualToString:@"优惠券已过期"]) {
        self.timeLabel.text = @"拼团截止";
    }else {
        self.timeLabel.text =timeStr;
    }
}
@end
