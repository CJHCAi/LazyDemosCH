//
//  NeedRushCell.m
//  ListV
//
//  Created by imac on 16/7/26.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "NeedRushCell.h"

@implementation NeedRushCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

-(void)initView{
    CGFloat w = self.frame.size.width;
    _goodNameLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, w, 15)];
    [self.contentView addSubview:_goodNameLb];
    _goodNameLb.font = MFont(12);
    _goodNameLb.textColor = LH_RGBCOLOR(90, 90, 90);
    _goodNameLb.textAlignment = NSTextAlignmentCenter;

    _goodIV = [[UIImageView alloc]initWithFrame:CGRectMake(15, CGRectYH(_goodNameLb)+5, w-30, w-30)];
    [self.contentView addSubview:_goodIV];

    _payMoneyLb = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectYH(_goodIV)+10, w/2, 15)];
    [self.contentView addSubview:_payMoneyLb];
    _payMoneyLb.textAlignment = NSTextAlignmentRight;
    _payMoneyLb.font = MFont(11);
    _payMoneyLb.textColor = [UIColor redColor];

    _quoteLb = [[UILabel alloc]initWithFrame:CGRectMake(CGRectXW(_payMoneyLb), CGRectYH(_goodIV)+12, w/2, 12)];
    [self.contentView addSubview:_quoteLb];
    _quoteLb.textAlignment = NSTextAlignmentLeft;
    _quoteLb.textColor = [UIColor lightGrayColor];
    _quoteLb.font = MFont(9);
    

}

@end
