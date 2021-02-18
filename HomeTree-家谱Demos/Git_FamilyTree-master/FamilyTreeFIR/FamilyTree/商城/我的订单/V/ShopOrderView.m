//
//  ShopOrderView.m
//  ListV
//
//  Created by imac on 16/8/1.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "ShopOrderView.h"

@implementation ShopOrderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView{
    UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, 1)];
    [self addSubview:lineV];
    lineV.backgroundColor = LH_RGBCOLOR(220, 220, 220);

    _goodIV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, __kWidth*8/45, __kWidth*8/45)];
    [self addSubview:_goodIV];

    _goodNameLb = [[UILabel alloc]initWithFrame:CGRectMake(CGRectXW(_goodIV)+10, 11, __kWidth*19/36, 30)];
    [self addSubview:_goodNameLb];
    _goodNameLb.font = MFont(12);
    _goodNameLb.textAlignment = NSTextAlignmentLeft;
    _goodNameLb.numberOfLines = 0;

    _moneyLb = [[UILabel alloc]initWithFrame:CGRectMake(__kWidth-60, 11, 45, 15)];
    [self addSubview:_moneyLb];
    _moneyLb.font = MFont(12);
    _moneyLb.textAlignment = NSTextAlignmentRight;

    _quoteLb = [[UILabel alloc]initWithFrame:CGRectMake(__kWidth-55, CGRectYH(_moneyLb), 40, 15)];
    [self addSubview:_quoteLb];
    _quoteLb.font = MFont(12);
    _quoteLb.textColor = [UIColor grayColor];
    _quoteLb.textAlignment = NSTextAlignmentRight;

    _orderNOLb = [[UILabel alloc]initWithFrame:CGRectMake(CGRectXW(_goodIV)+10, CGRectYH(_goodNameLb), __kWidth*19/36+50, 30)];
    [self addSubview:_orderNOLb];
    _orderNOLb.font = MFont(11);
    _orderNOLb.textAlignment = NSTextAlignmentLeft;

    _countLb = [[UILabel alloc]initWithFrame: CGRectMake(__kWidth-40, CGRectYH(_quoteLb)+5, 25, 15)];
    [self addSubview:_countLb];
    _countLb.textColor = [UIColor grayColor];
    _countLb.textAlignment = NSTextAlignmentRight;
    _countLb.font = MFont(11);

    UIView *linV = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-1, __kWidth, 1)];
    [self addSubview:linV];
    linV.backgroundColor = LH_RGBCOLOR(220, 220, 220);
}

@end
