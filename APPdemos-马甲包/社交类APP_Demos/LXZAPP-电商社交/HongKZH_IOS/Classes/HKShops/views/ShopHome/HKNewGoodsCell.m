//
//  HKNewGoodsCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKNewGoodsCell.h"

@interface HKNewGoodsCell ()

@property (nonatomic, strong)UIImageView *cover;
@property (nonatomic, strong)UILabel * titleLabel;
@property (nonatomic, strong)UILabel *priceLabel;

@end

@implementation HKNewGoodsCell
{
    CGFloat itemW ;
}
-(instancetype)initWithFrame:(CGRect)frame {
    if (self =[super initWithFrame:frame]) {
        
        itemW = (kScreenWidth -15*2 -10*2)/3;
        self.backgroundColor =[UIColor whiteColor];
        [self addSubview:self.cover];
        [self addSubview:self.titleLabel];
        [self addSubview:self.priceLabel];
    }
    return self;
}

-(UIImageView *)cover {
    if (!_cover) {
        _cover =[[UIImageView alloc] initWithFrame:CGRectMake(0,15,itemW,itemW)];
        _cover.image =[UIImage imageNamed:@"wdsc_cnxh_02"];
    }
    return _cover;
}
-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.cover.frame),CGRectGetMaxY(self.cover.frame)+10,CGRectGetWidth(self.cover.frame),40)];
        [AppUtils getConfigueLabel:_titleLabel font:PingFangSCRegular12 aliment:NSTextAlignmentLeft textcolor:RGB(102,102,102) text:@"香港2018秋季黑色乐福鞋看脚跟厚重百搭拼读投机让退"];
        _titleLabel.numberOfLines =0;
        
    }
    return _titleLabel;
}
-(UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame),CGRectGetMaxY(self.titleLabel.frame)+10,CGRectGetWidth(self.titleLabel.frame),10)];
        [AppUtils getConfigueLabel:_priceLabel font:PingFangSCRegular12 aliment:NSTextAlignmentLeft textcolor:RGB(239,89,60) text:@"￥299"];
    }
    return _priceLabel;
}
-(void)setList:(HKShopNewGoodsProduct *)list {
    _list = list;
    self.titleLabel.text = list.title;
    [self.cover sd_setImageWithURL:[NSURL URLWithString:list.imgSrc]];
    self.priceLabel.text =[NSString  stringWithFormat:@"￥%%.2lf",list.integral];
}
@end
