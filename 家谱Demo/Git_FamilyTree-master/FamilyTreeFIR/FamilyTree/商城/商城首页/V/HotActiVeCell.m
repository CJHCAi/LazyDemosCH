//
//  HotActiVeCell.m
//  ListV
//
//  Created by imac on 16/7/22.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "HotActiVeCell.h"

@implementation HotActiVeCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initView];
    }
    return self;
}

- (void)initView{
    CGFloat labelW = (__kWidth-80)/14*3;
    CGFloat imgW = (__kWidth-80)/14*4;
    _goodNameLb = [[UILabel alloc]initWithFrame:CGRectMake(15, 8, labelW, 30)];
    [self.contentView addSubview:_goodNameLb];
    _goodNameLb.numberOfLines = 0;
    _goodNameLb.textColor = LH_RGBCOLOR(90, 90, 90);
    _goodNameLb.textAlignment = NSTextAlignmentLeft;
    _goodNameLb.font = MFont(10);

    UILabel *hotLb = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectYH(_goodNameLb), labelW, 15)];
    [self.contentView addSubview:hotLb];
    hotLb.textAlignment = NSTextAlignmentLeft;
    hotLb.textColor = [UIColor redColor];
    hotLb.font = MFont(11);
    hotLb.text = @"热销直供";

    _payMoneyLb = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectYH(hotLb), labelW, 15)];
    [self.contentView addSubview:_payMoneyLb];
    _payMoneyLb.textAlignment = NSTextAlignmentLeft;
    _payMoneyLb.font = MFont(12);
    _payMoneyLb.textColor = [UIColor redColor];

    _quoteLb = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectYH(_payMoneyLb), labelW, 15)];
    [self.contentView addSubview:_quoteLb];
    _quoteLb.font = MFont(11);
    _quoteLb.textAlignment = NSTextAlignmentLeft;
    _quoteLb.textColor = [UIColor lightGrayColor];

    _goodIV = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectXW(_goodNameLb)+10, 10, imgW, imgW)];
    [self.contentView addSubview:_goodIV];
    _goodIV.contentMode = UIViewContentModeScaleAspectFit;

}

@end
