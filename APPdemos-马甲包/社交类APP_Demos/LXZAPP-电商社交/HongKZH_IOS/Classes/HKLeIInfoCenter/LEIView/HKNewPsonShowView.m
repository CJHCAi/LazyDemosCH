//
//  HKNewPsonShowView.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/30.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKNewPsonShowView.h"

@interface HKNewPsonShowView ()
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIImageView *rootImageView;
@property (weak, nonatomic) IBOutlet UIButton *CancleBtn;

@property (nonatomic,weak)UIImageView *head;

@property (nonatomic, weak)UILabel *nameLabel;

@property (nonatomic,weak)UILabel *tipsLabel;


@property (nonatomic, weak)UIImageView *letView;
@property (nonatomic, weak)UILabel *messageLabel;
@property (nonatomic, weak)UIImageView *coinIm;
@property (nonatomic, weak)UILabel *numLabel;


@property (nonatomic, weak)UIImageView * bottomV;
@property (nonatomic, weak)UIImageView * personIm;
@property (nonatomic, weak)UILabel * personLabel;
@property (nonatomic, weak)UIImageView *coponV;
@property (nonatomic, weak)UIView *line;
@property (nonatomic, weak)UILabel *goodLabel;
@property (nonatomic, weak)UIButton *justUSe;

@property (nonatomic, weak)UILabel * storgeLabel;

@end


@implementation HKNewPsonShowView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"HKNewPsonShowView" owner:self options:nil].lastObject;
        self.frame = CGRectMake(0,0,kScreenWidth,kScreenHeight);
        [self addSubview:self.contentView];
        self.contentView.backgroundColor =[[UIColor blackColor] colorWithAlphaComponent:0.6];
        self.rootImageView.image  =[UIImage imageNamed:@"new_bg"];
        self.rootImageView.layer.cornerRadius =10;
        self.rootImageView.layer.masksToBounds = YES;
        self.contentView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tabCon =[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(tapClick:)];
        [self.contentView addGestureRecognizer:tabCon];
        
    }
    return self;
}
-(void)tapClick:(UITapGestureRecognizer *)ge {
    [self removeFromSuperview];
}
-(UIImageView *)head {
    if (!_head) {
       UIImageView *head =[[UIImageView alloc] init];
        [AppUtils seImageView:head withUrlSting:[LoginUserData sharedInstance].headImg placeholderImage:kPlaceholderImage];
        [self.rootImageView addSubview:head];
        _head = head;
    }
    return _head;
}
-(UILabel *)nameLabel {
    if (!_nameLabel) {
        UILabel *label =[[UILabel alloc] init];
        [AppUtils getConfigueLabel:label font:PingFangSCMedium23 aliment:NSTextAlignmentCenter textcolor:[UIColor whiteColor] text:@""];
        [self.rootImageView addSubview:label];
        label.text =[LoginUserData sharedInstance].name;
        _nameLabel = label;
    }
    return _nameLabel;
}
-(UILabel *)tipsLabel {
    if (!_tipsLabel) {
        UILabel *label =[[UILabel alloc] init];
        [AppUtils getConfigueLabel:label font:PingFangSCMedium18 aliment:NSTextAlignmentCenter textcolor:[UIColor colorFromHexString:@"FFCF61"] text:@"注册成为乐小转会员"];
        [self.rootImageView addSubview:label];
        _tipsLabel = label;
    }
    return _tipsLabel;
}

-(UIImageView *)letView {
    if (!_letView) {
        UIImageView *head =[[UIImageView alloc] init];
        head.image =[UIImage imageNamed:@"gxhd"];
        [self.rootImageView addSubview:head];
        _letView = head;
    }
    return _letView;
}
-(UILabel *)messageLabel {
    if (!_messageLabel) {
        UILabel *label =[[UILabel alloc] init];
        [AppUtils getConfigueLabel:label font:PingFangSCMedium15 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@"恭喜您获得"];
        [self.letView addSubview:label];
        _messageLabel = label;
        
    }
    return _messageLabel;
}
-(UILabel *)numLabel {
    if (!_numLabel) {
        UILabel *label =[[UILabel alloc] init];
        [AppUtils getConfigueLabel:label font:BoldFont20 aliment:NSTextAlignmentRight textcolor:keyColor text:@"100"];
        [self.letView addSubview:label];
        _numLabel = label;
    }
    return _numLabel;
}
-(UIImageView *)coinIm {
    if (!_coinIm) {
        UIImageView *head =[[UIImageView alloc] init];
        head.image =[UIImage imageNamed:@"jb"];
        [self.letView addSubview:head];
        _coinIm = head;
    }
    return _coinIm;
}

-(UILabel *)storgeLabel {
    if (!_storgeLabel) {
        UILabel *label =[[UILabel alloc] init];
        [AppUtils getConfigueLabel:label font:PingFangSCMedium12 aliment:NSTextAlignmentCenter textcolor:[UIColor colorFromHexString:@"962227"] text:@"(已存入您的储物箱)"];
        [self.rootImageView addSubview:label];
        _storgeLabel = label;
    }
    return _storgeLabel;
}

-(UIImageView *)bottomV {
    if (!_bottomV) {
        UIImageView *head =[[UIImageView alloc] init];
        head.image =[UIImage imageNamed:@"xrzxzgq"];
        [self.rootImageView addSubview:head];
        _bottomV = head;
    }
    return _bottomV;
}

-(UIImageView *)personIm {
    if (!_personIm) {
        UIImageView *head =[[UIImageView alloc] init];
        head.image =[UIImage imageNamed:@"yhq_xrzxq"];
        [self.rootImageView addSubview:head];
        _personIm = head;
    }
    return _personIm;
}
-(UILabel *)personLabel {
    if (!_personLabel) {
        UILabel *label =[[UILabel alloc] init];
        [AppUtils getConfigueLabel:label font:PingFangSCMedium15 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@"新人专享折扣资格劵"];
        [self.bottomV addSubview:label];
        _personLabel = label;
    }
    return _personLabel;
    
}
-(UIImageView *)coponV {
    if (!_coponV) {
        UIImageView *head =[[UIImageView alloc] init];
        head.image =[UIImage imageNamed:@"zgq"];
        [self.bottomV addSubview:head];
        _coponV = head;
    }
    return _coponV;
}

-(UILabel *)goodLabel {
    if (!_goodLabel) {
        UILabel *label =[[UILabel alloc] init];
        [AppUtils getConfigueLabel:label font:PingFangSCMedium12 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"999999"] text:@"实物商品"];
        [self.bottomV addSubview:label];
        _goodLabel = label;
    }
    return _goodLabel;
}

-(UIButton *)justUSe {
    if (!_justUSe) {
        UIButton *b =[UIButton buttonWithType:UIButtonTypeCustom];
        b.frame = CGRectZero;
        [AppUtils getButton:b font:PingFangSCMedium12 titleColor:keyColor title:@"立即使用"];
        b.layer.cornerRadius =5;
        b.layer.masksToBounds =YES;
        b.borderWidth= 1;
        b.borderColor =keyColor;
        b.backgroundColor =[UIColor whiteColor];
        [b addTarget:self action:@selector(useClick) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomV addSubview:b];
        _justUSe = b;
    }
    return _justUSe;
}
-(void)useClick {
    [self removeFromSuperview];
}
- (IBAction)Leave:(id)sender {
    [self removeFromSuperview];
}
-(void)layoutSubviews {
    [self.head mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rootImageView).offset(34);
        make.width.height.mas_equalTo(66);
        make.centerX.equalTo(self.rootImageView);
    }];
    self.head.layer.cornerRadius =33;
    self.head.layer.masksToBounds =YES;
    self.head.borderColor =[UIColor whiteColor];
    self.head.borderWidth =2;
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.head.mas_bottom).offset(10);
        make.centerX.equalTo(self.head);
        make.height.mas_equalTo(44);
    
    }];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.nameLabel);
        make.height.mas_equalTo(18);
        
    }];
    [self.letView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipsLabel.mas_bottom).offset(25);
        make.left.equalTo(self.rootImageView).offset(10);
        make.right.equalTo(self.rootImageView).offset(-10);
        make.height.mas_equalTo(45);
        
    }];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.letView).offset(15);
        make.top.equalTo(self.letView).offset(15);
        make.bottom.equalTo(self.letView).offset(-15);
    
    }];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.letView).offset(-15);
        make.top.equalTo(self.letView).offset(13);
        make.bottom.equalTo(self.letView).offset(-11.5);
    }];
    [self.coinIm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.numLabel.mas_left).offset(-5);
        make.width.height.equalTo(self.numLabel.mas_height);
        make.top.equalTo(self.numLabel);
        
    }];
    [self.storgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.rootImageView).offset(-8);
        make.centerX.equalTo(self.rootImageView);
        make.height.mas_equalTo(12);
    }];
    //最后一个..
    [self.bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.letView);
        make.right.equalTo(self.letView);
        make.top.equalTo(self.letView.mas_bottom).offset(10);
        make.height.mas_equalTo(122);
        
    }];
    [self.personIm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomV).offset(13);
        make.top.equalTo(self.bottomV).offset(13);
        make.width.height.mas_equalTo(63);
    }];
    [self.personLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.personIm.mas_right).offset(10);
        make.top.equalTo(self.personIm).offset(6);
        make.height.mas_equalTo(16);
        
    }];
    [self.coponV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.personLabel);
        make.top.equalTo(self.personLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(42);
        make.height.mas_equalTo(15);
        
    }];
    [self.goodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.personIm);
        make.bottom.equalTo(self.bottomV.mas_bottom).offset(-12);
        make.height.mas_equalTo(12);
        
    }];
    [self.justUSe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomV.mas_right).offset(-13);
        make.bottom.equalTo(self.bottomV.mas_bottom).offset(-7);
        make.width.mas_equalTo(66);
        make.height.mas_equalTo(22);
    }];
}

@end
