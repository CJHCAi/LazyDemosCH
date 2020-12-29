//
//  HK_transHeaderView.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/31.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_transHeaderView.h"

@interface HK_transHeaderView ()

@property (nonatomic, strong)UILabel * orderLabel;
//快递号
@property (nonatomic, strong)UILabel *orderNUmberLabel;
@property (nonatomic, strong)UILabel *carrieLabel;
//快递运营商

@property (nonatomic, strong)UILabel *carrieNameLabel;
@property (nonatomic, strong)UIView *bootmView;

@end

@implementation HK_transHeaderView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self =[super initWithFrame:frame]) {
        self.backgroundColor =[UIColor whiteColor];
        [self addSubview:self.orderLabel];
        [self addSubview:self.orderNUmberLabel];
        [self addSubview:self.carrieLabel];
        [self addSubview:self.carrieNameLabel];
        [self addSubview:self.bootmView];
        
        [self layoutSubviews];
    }
    return self;
}

-(UILabel *)orderLabel {
    if (!_orderLabel) {
        _orderLabel =[[UILabel alloc] init];
        [AppUtils getConfigueLabel:_orderLabel font:PingFangSCMedium13 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@"快递单号:"];
    }
    return _orderLabel;
}
-(UILabel *)orderNUmberLabel {
    if (!_orderNUmberLabel) {
        _orderNUmberLabel =[[UILabel alloc] init];
        [AppUtils getConfigueLabel:_orderNUmberLabel font:PingFangSCRegular13 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@"37261195"];
    }
    return _orderNUmberLabel;
}
-(UILabel *)carrieLabel {
    if (!_carrieLabel) {
        _carrieLabel =[[UILabel alloc] init];
        [AppUtils getConfigueLabel:_carrieLabel font:PingFangSCMedium13 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@"快递名称:"];
    }
    return _carrieLabel;
}
-(UILabel *)carrieNameLabel {
    if (!_carrieNameLabel) {
        _carrieNameLabel =[[UILabel alloc] init];
        [AppUtils getConfigueLabel:_carrieNameLabel font:PingFangSCRegular13 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@"圆通快递"];
    }
    return _carrieNameLabel;
}
-(UIView *)bootmView {
    if (!_bootmView) {
        _bootmView =[[UIView alloc] init];
        _bootmView.backgroundColor =UICOLOR_RGB_Alpha(0xf2f2f2, 1);
    }
    return _bootmView;
}
-(void)layoutSubviews {
    self.orderLabel.frame = CGRectMake(15,20,60,15);
    self.orderNUmberLabel.frame = CGRectMake(CGRectGetMaxX(self.orderLabel.frame),CGRectGetMinY(self.orderLabel.frame),140,CGRectGetHeight(self.orderLabel.frame));
    
    self.carrieLabel.frame = CGRectMake(CGRectGetMinX(self.orderLabel.frame),CGRectGetMaxY(self.orderLabel.frame)+15,CGRectGetWidth(self.orderLabel.frame),CGRectGetHeight(self.orderLabel.frame));
    
    self.carrieNameLabel.frame =CGRectMake(CGRectGetMinX(self.orderNUmberLabel.frame),CGRectGetMinY(self.carrieLabel.frame),CGRectGetWidth(self.orderNUmberLabel.frame),CGRectGetHeight(self.orderNUmberLabel.frame));
    
    self.bootmView.frame = CGRectMake(0,80,kScreenWidth,10);
}
-(void)setDataWithOrderNumber:(NSString *)orderNumbr andCouriesName:(NSString *)couriesName{
    self.orderNUmberLabel.text =orderNumbr;
    self.carrieNameLabel.text =couriesName;
    
}
@end
