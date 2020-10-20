//
//  OrderAddressView.m
//  ListV
//
//  Created by imac on 16/8/2.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "OrderAddressView.h"

@implementation OrderAddressView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)initView{
    UIImageView *lineIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, 6)];
    [self addSubview:lineIV];
    lineIV.image = MImage(@"line");
    lineIV.contentMode = UIViewContentModeScaleAspectFit;

    _nameLb = [[UILabel alloc]initWithFrame:CGRectMake(35, 20, 80, 15)];
    [self addSubview:_nameLb];
    _nameLb.font = MFont(14);
    _nameLb.textAlignment = NSTextAlignmentLeft;

    _mobileLb = [[UILabel alloc]initWithFrame:CGRectMake(__kWidth*13/18+35-130, 20, 95, 15)];
    [self addSubview:_mobileLb];
    _mobileLb.font = MFont(14);
    _mobileLb.textAlignment = NSTextAlignmentLeft;

    _defaultLb = [[UILabel alloc]initWithFrame:CGRectMake(CGRectXW(_mobileLb), 18, 35, 17)];
    [self addSubview:_defaultLb];
    _defaultLb.font = MFont(15);
    _defaultLb.backgroundColor = [UIColor redColor];
    _defaultLb.textColor = [UIColor whiteColor];
    _defaultLb.textAlignment = NSTextAlignmentCenter;
    _defaultLb.text = @"默认";

    UIImageView *locationIV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 40, 15, 20)];
    [self addSubview:locationIV];
    locationIV.image = MImage(@"place");

    _addressLb = [[UILabel alloc]initWithFrame:CGRectMake(35, CGRectYH(_nameLb)+10, __kWidth*13/18, 30)];
    [self addSubview:_addressLb];
    _addressLb.font = MFont(12);
    _addressLb.textAlignment = NSTextAlignmentLeft;
    _addressLb.numberOfLines = 0;
    _addressLb.textColor = LH_RGBCOLOR(120, 120, 120);

    UIView *spaceV =[[UIView alloc]initWithFrame:CGRectMake(0, CGRectYH(_addressLb)+10, __kWidth, 10)];
    [self addSubview:spaceV];
    spaceV.backgroundColor = LH_RGBCOLOR(230, 230, 230);

}

@end
