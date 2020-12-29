//
//  HK_footViewPayView.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_footViewPayView.h"
#import "HK_orderTool.h"
@implementation HK_footViewPayView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithReuseIdentifier:reuseIdentifier];

    if (self) {
        self.contentView.backgroundColor =[UIColor whiteColor];
        [self.contentView addSubview:self.totipsLabel];
       // [self.contentView addSubview:self.payTimeBtn];
        [self.contentView addSubview:self.payTimeLabel];


    }
    return self;
}

//-(instancetype)initWithFrame:(CGRect)frame {
//    self =[super initWithFrame:frame];
//    if (self) {
//        self.backgroundColor =[UIColor whiteColor];
//        [self addSubview:self.totipsLabel];
//        [self addSubview:self.payTimeBtn];
//
//    }
//    return  self;
//}
-(UILabel *)totipsLabel {
    if (!_totipsLabel) {
        _totipsLabel =[[UILabel alloc] initWithFrame:CGRectMake(15,0,280,48)];
        [AppUtils getConfigueLabel:_totipsLabel font:PingFangSCRegular13 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@""];
    }
    return _totipsLabel;
}
-(UILabel *)payTimeLabel {
    if (!_payTimeLabel) {
        _payTimeLabel =[[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-108-10,10,108,28)];
        _payTimeLabel.layer.cornerRadius = 4;
        _payTimeLabel.backgroundColor =[UIColor colorFromHexString:@"#d45048"];
        _payTimeLabel.layer.masksToBounds =YES;
        [AppUtils getConfigueLabel:_payTimeLabel font:PingFangSCRegular13 aliment:NSTextAlignmentCenter textcolor:[UIColor whiteColor] text:@""];
    }
    return _payTimeLabel;
}
//-(UIButton *)payTimeBtn {
//    if (!_payTimeBtn) {
//        _payTimeBtn =[UIButton buttonWithType:UIButtonTypeCustom];
//        _payTimeBtn.frame = CGRectMake(kScreenWidth-108-10,10,108,28);
//        _payTimeBtn.layer.cornerRadius =4;
//        _payTimeBtn.backgroundColor =[UIColor colorFromHexString:@"d45048"];
//        _payTimeBtn.layer.masksToBounds = YES;
//        [_payTimeBtn setTitleColor:[UIColor colorFromHexString:@"ffffff"] forState:UIControlStateNormal];
//        [_payTimeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_payTimeBtn addTarget:self action:@selector(lastForPay) forControlEvents:UIControlEventTouchUpInside];
//        [_payTimeBtn setTitle:@"" forState:UIControlStateNormal];
//        _payTimeBtn.titleLabel.font =PingFangSCRegular13;
//    }
//    return _payTimeBtn;
//}
-(void)lastForPay {
    if (self.delegete && [self.delegete respondsToSelector:@selector(payOrderClick:)]) {
        [self.delegete payOrderClick:self.listOrder];
    }
}
-(void)setListOrder:(HK_shopOrderList *)listOrder{
#pragma mark 修改显示样式..
    //总计
    NSInteger valueTotal  =listOrder.integral;
    //运费
    NSInteger transTotal  =listOrder.freightIntegral;
    NSMutableAttributedString * attbuteOne =[AppUtils configueLabelAtLeft:YES andCount:valueTotal];
    NSMutableAttributedString *attbuteTwo =[AppUtils configueLabelAtLeft:YES andCount:transTotal];
    NSMutableAttributedString * tipsAtt=[[NSMutableAttributedString alloc] initWithString:@"总计: "];
    [tipsAtt appendAttributedString:attbuteOne];
    NSMutableAttributedString * tipTwo =[[NSMutableAttributedString alloc] initWithString:@" (含运费 "];
    NSMutableAttributedString *tipsThree =[[NSMutableAttributedString alloc] initWithString:@")"];
    [tipsAtt appendAttributedString:tipTwo];
    [tipsAtt appendAttributedString:attbuteTwo];
    [tipsAtt appendAttributedString:tipsThree];
  //   self.totipsLabel.attributedText = tipsAtt;
    NSString *string =@"总计: ";
    NSString * stringOne =[NSString stringWithFormat:@"￥%zd",valueTotal];
    NSString * StringTwo =[NSString stringWithFormat:@"(含运费￥%zd)",transTotal];
    self.totipsLabel.text =[NSString stringWithFormat:@"%@%@%@",string,stringOne,StringTwo];

    NSTimeInterval timer =[HK_orderTool AgetCountTimeWithString:listOrder.limitTime andNowTime:listOrder.currentTime];
    if (self.timer==0) {
        
         self.timer = timer;
    }
    NSString * dates =[HK_orderTool getDataStringFromTimeCount:timer];
    self.payTimeLabel.text = dates;
    // [self.payTimeBtn setTitle:dates forState:UIControlStateNormal];
}

@end
