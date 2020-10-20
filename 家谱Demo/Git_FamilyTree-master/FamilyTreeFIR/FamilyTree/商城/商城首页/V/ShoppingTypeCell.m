//
//  ShoppingTypeCell.m
//  ListV
//
//  Created by imac on 16/7/22.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "ShoppingTypeCell.h"

@implementation ShoppingTypeCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

-(void)initView{
    CGFloat w =self.frame.size.width;
    _typeIV = [[UIImageView alloc]initWithFrame:CGRectMake(24, 15, w-48, w-48)];
    [self addSubview:_typeIV];
    _typeIV.layer.cornerRadius = 2;

    _typeLb = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectYH(_typeIV)+5, w, 15)];
    [self addSubview:_typeLb];
    _typeLb.font = MFont(14);
    _typeLb.textColor = LH_RGBCOLOR(90, 90, 90);
    _typeLb.textAlignment = NSTextAlignmentCenter;

}

@end
