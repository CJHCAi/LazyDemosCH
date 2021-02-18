
//
//  GuessLikeCell.m
//  ListV
//
//  Created by imac on 16/7/26.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "GuessLikeCell.h"

@interface GuessLikeCell()

@end

@implementation GuessLikeCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super  initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initView];
    }
    return self;
}

- (void)initView{
    _goodIV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, __kWidth*5/12, __kWidth*5/18)];
    [self.contentView addSubview:_goodIV];

    _goodNameLb = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectYH(_goodIV)+5, __kWidth*5/12, 30)];
    [self.contentView addSubview:_goodNameLb];
    _goodNameLb.font = MFont(10);
    _goodNameLb.textAlignment = NSTextAlignmentLeft;
    _goodNameLb.textColor = LH_RGBCOLOR(90, 90, 90);
    _goodNameLb.numberOfLines =0;

    _payMoneyLb = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectYH(_goodNameLb)+10, 45, 15)];
    [self.contentView addSubview:_payMoneyLb];
    _payMoneyLb.textColor = [UIColor redColor];
    _payMoneyLb.font = MFont(11);
    _payMoneyLb.textAlignment = NSTextAlignmentLeft;

    _quoteLb = [[UILabel alloc]initWithFrame:CGRectMake(CGRectXW(_payMoneyLb), CGRectYH(_goodNameLb)+11, 60, 15)];
    [self.contentView addSubview:_quoteLb];
    _quoteLb.font = MFont(10);
    _quoteLb.textAlignment = NSTextAlignmentLeft;
    _quoteLb.textColor = [UIColor lightGrayColor];

    _shoppingBtn = [[UIButton alloc]initWithFrame:CGRectMake(__kWidth*5/12-7-6, CGRectYH(_goodNameLb)+5-6, 29, 29)];
    [self.contentView addSubview:_shoppingBtn];
    [_shoppingBtn setImage:MImage(@"cart") forState:0];
    
}

@end
