//
//  HK_chargeBtn.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_chargeBtn.h"

@implementation HK_chargeBtn

-(instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled =YES;
        self.layer.cornerRadius =3;
        self.layer.masksToBounds = YES;
        self.layer.borderColor =[RGB(229,229,229) CGColor];
        self.layer.borderWidth =1;
        [self addSubview:self.CoinLabel];
        [self addSubview:self.RmbLabel];
        UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapH)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
-(void)tapH {
    
    if (self.delegete && [self.delegete respondsToSelector:@selector(clickChageV:)]) {
        [self.delegete clickChageV:self.mdoel];
    }
}
-(UILabel *)CoinLabel {
    if (!_CoinLabel) {
        _CoinLabel =[[UILabel alloc] initWithFrame:CGRectMake(0,10,self.frame.size.width,20)];
        [AppUtils getConfigueLabel:_CoinLabel font:PingFangSCRegular14 aliment:NSTextAlignmentCenter textcolor:[UIColor colorFromHexString:@"666666"] text:@"600乐币"];
    }
    return _CoinLabel;
}
-(UILabel *)RmbLabel {
    if (!_RmbLabel) {
        _RmbLabel =[[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.CoinLabel.frame)+5,CGRectGetWidth(self.CoinLabel.frame),10)];
        [AppUtils getConfigueLabel:_RmbLabel font:PingFangSCRegular13 aliment:NSTextAlignmentCenter textcolor:[UIColor redColor] text:@"50元"];
        
    }
    return _RmbLabel;
}

@end
