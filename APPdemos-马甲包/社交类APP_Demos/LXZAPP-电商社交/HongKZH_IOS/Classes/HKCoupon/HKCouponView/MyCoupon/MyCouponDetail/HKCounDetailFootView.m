//
//  HKCounDetailFootView.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/30.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCounDetailFootView.h"

@interface HKCounDetailFootView ()
@property (nonatomic, strong)UIView *lineV;
@property (nonatomic, strong)UILabel * tipsLabel;
@property (nonatomic, strong)UILabel * tipsOneLabel;
@property (nonatomic, strong)UILabel *tipsTwoLabel;

@end

@implementation HKCounDetailFootView
-(instancetype)initWithFrame:(CGRect)frame {
    if (self =[super initWithFrame:frame]) {
        self.backgroundColor =[UIColor whiteColor];
        [self addSubview:self.lineV];
        [self addSubview:self.tipsLabel];
        [self addSubview:self.tipsOneLabel];
        [self addSubview:self.tipsTwoLabel];
        
    }
    return self;
}

-(UIView *)lineV {
    if (!_lineV) {
        _lineV =[[UIView alloc] initWithFrame:CGRectMake(15,0,kScreenWidth-15,1)];
        _lineV.backgroundColor = RGB(226,226,226);
    }
    return _lineV;
}
-(UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel =[[UILabel alloc] initWithFrame:CGRectMake(15,15,200,14)];
        [AppUtils getConfigueLabel:_tipsLabel font:PingFangSCRegular14 aliment:NSTextAlignmentLeft textcolor:RGB(153,153,153) text:@"温馨提示:"];

    }
    return _tipsLabel;
}
-(UILabel *)tipsOneLabel {
    if (!_tipsOneLabel) {
        _tipsOneLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.tipsLabel.frame),CGRectGetMaxY(self.tipsLabel.frame)+10,300,20)];
        [AppUtils getConfigueLabel:_tipsOneLabel font:PingFangSCRegular14 aliment:NSTextAlignmentLeft textcolor:RGB(51,51,51) text:@"1.可在集市溢价出售"];
    }
    return _tipsOneLabel;
}
-(UILabel *)tipsTwoLabel {
    if (!_tipsTwoLabel) {
        _tipsTwoLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.tipsLabel.frame),CGRectGetMaxY(self.tipsOneLabel.frame)+10,CGRectGetWidth(self.tipsOneLabel.frame),CGRectGetHeight(self.tipsOneLabel.frame))];
          [AppUtils getConfigueLabel:_tipsTwoLabel font:PingFangSCRegular14 aliment:NSTextAlignmentLeft textcolor:RGB(51,51,51) text:@"2.本折扣仅可在本商铺使用"];
    }
    return _tipsTwoLabel;
}

@end
