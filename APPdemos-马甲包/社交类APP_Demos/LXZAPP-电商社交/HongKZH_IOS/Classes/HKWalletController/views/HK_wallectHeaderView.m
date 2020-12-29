//
//  HK_wallectHeaderView.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_wallectHeaderView.h"

@implementation HK_wallectHeaderView

-(instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        self.backgroundColor =[UIColor whiteColor];
        self.userInteractionEnabled = YES;
        [self layoutSubviews];
    }
    return self
    ;
}

-(void)layoutSubviews {
    
    [self addSubview: self.todayTipsLabel];
    [self addSubview: self.todayCountLabel];
    [self addSubview:self.totalTipsLabel];
    [self addSubview:self.totalCountLabel];
    [self addSubview:self.messageLabel];
    [self addSubview:self.supplyBtn];
  //  [self addSubview:self.withDralBtn];

}

-(UILabel *)todayTipsLabel {
    if (!_todayTipsLabel) {
        _todayTipsLabel =[[UILabel alloc] init];
        [AppUtils getConfigueLabel:_todayTipsLabel font:PingFangSCRegular12 aliment:NSTextAlignmentCenter textcolor:[UIColor colorFromHexString:@"333333"] text:@"今日收入"];
        _todayTipsLabel.frame= CGRectMake(0,30,SCREEN_WIDTH_S,20);
    }
    return _todayTipsLabel;
    
}
-(UILabel *)todayCountLabel {
    if (!_todayCountLabel) {
        _todayCountLabel =[[UILabel alloc] init];
        [AppUtils getConfigueLabel:_todayCountLabel font:[UIFont systemFontOfSize:30] aliment:NSTextAlignmentCenter textcolor:[UIColor colorFromHexString:@"e15640"] text:@""];
        _todayCountLabel.frame= CGRectMake(0,CGRectGetMaxY(self.todayTipsLabel.frame)+5,SCREEN_WIDTH_S,30);
    }
    return _todayCountLabel;
}

-(UILabel *)totalTipsLabel {
    if (!_totalTipsLabel) {
        _totalTipsLabel =[[UILabel alloc] init];
        [AppUtils getConfigueLabel:_totalTipsLabel font:[UIFont systemFontOfSize:12] aliment:NSTextAlignmentCenter textcolor:[UIColor colorFromHexString:@"333333"] text:@"总资产"];
        _totalTipsLabel.frame= CGRectMake(0,CGRectGetMaxY(self.todayCountLabel.frame)+20,SCREEN_WIDTH_S,CGRectGetHeight(self.todayTipsLabel.frame));
    }
    return _totalTipsLabel;
}
-(UILabel *)totalCountLabel {
    if (!_totalCountLabel) {
        _totalCountLabel =[[UILabel alloc] init];
        [AppUtils getConfigueLabel:_totalCountLabel font:[UIFont systemFontOfSize:30] aliment:NSTextAlignmentCenter textcolor:[UIColor colorFromHexString:@"333333"] text:@"56543"];
        _totalCountLabel.frame= CGRectMake(0,CGRectGetMaxY(self.totalTipsLabel.frame)+5,SCREEN_WIDTH_S,30);
        _totalCountLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer * tapTotal =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushIncomeVc)];
        [_totalCountLabel addGestureRecognizer:tapTotal];
    }
    
    return _totalCountLabel;
}
//跳转至我的资产
-(void)pushIncomeVc {
    if (self.delegete && [self.delegete respondsToSelector:@selector(enterMyIncomeVc)]) {
        [self.delegete enterMyIncomeVc];
    }
}
-(UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel =[[UILabel alloc] init];
        [AppUtils getConfigueLabel:_messageLabel font:[UIFont systemFontOfSize:10] aliment:NSTextAlignmentCenter textcolor:[UIColor colorFromHexString:@"999999"] text:@"(100乐币等价于1元)"];
        _messageLabel.frame= CGRectMake(0,CGRectGetMaxY(self.totalCountLabel.frame)+15,SCREEN_WIDTH_S,10);
    }
    return _messageLabel;
}

-(UIButton *)supplyBtn {
    if (!_supplyBtn) {
        _supplyBtn =[UIButton  buttonWithType:UIButtonTypeCustom];
        _supplyBtn.frame = CGRectMake(15,CGRectGetMaxY(self.messageLabel.frame)+20,SCREEN_WIDTH_S-30,50);
        [AppUtils getButton:_supplyBtn font:PingFangSCRegular16 titleColor:[UIColor colorFromHexString:@"ffffff"] title:@"充值"];
        _supplyBtn.layer.cornerRadius = 5;
        _supplyBtn.layer.masksToBounds = YES;
        _supplyBtn.backgroundColor =[UIColor colorFromHexString:@"4a91df"];
        _supplyBtn.tag = 1;
        [_supplyBtn addTarget:self action:@selector(supplyPay:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _supplyBtn;
}

-(UIButton *)withDralBtn {
    if (!_withDralBtn) {
        _withDralBtn =[UIButton  buttonWithType:UIButtonTypeCustom];
        _withDralBtn.frame = CGRectMake(15,CGRectGetMaxY(self.supplyBtn.frame)+15,CGRectGetWidth(self.supplyBtn.frame),CGRectGetHeight(self.supplyBtn.frame));
        [AppUtils getButton:_withDralBtn font:PingFangSCRegular16 titleColor:[UIColor colorFromHexString:@"558ef0"] title:@"提现"];
        _withDralBtn.layer.cornerRadius = 5;
        _withDralBtn.layer.masksToBounds = YES;
        _withDralBtn.borderColor =[UIColor colorFromHexString:@"4a91df"];
        _withDralBtn.borderWidth =1;
        _withDralBtn.backgroundColor =[UIColor whiteColor];
        _withDralBtn.tag = 2;
        [_withDralBtn addTarget:self action:@selector(supplyPay:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _withDralBtn;
}
-(void)supplyPay:(UIButton *)sender {
    if (self.block) {
        self.block(sender.tag);
    }
}
@end
