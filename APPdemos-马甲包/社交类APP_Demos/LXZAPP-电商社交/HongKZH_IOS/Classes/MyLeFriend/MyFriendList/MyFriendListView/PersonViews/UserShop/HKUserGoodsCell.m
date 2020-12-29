//
//  HKUserGoodsCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/13.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKUserGoodsCell.h"

@interface HKUserGoodsCell ()
@property (nonatomic, strong)UIImageView *cover;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *priceLabel;
@end

@implementation HKUserGoodsCell
{
    CGFloat itemW ;
}
-(instancetype)initWithFrame:(CGRect)frame {
    if (self =[super initWithFrame:frame]) {
        itemW = (kScreenWidth -30)/2;
        self.backgroundColor =[UIColor whiteColor];
        [self addSubview:self.cover];
        [self addSubview:self.titleLabel];
        [self addSubview:self.priceLabel];
    }
    return self;
}

-(UIImageView *)cover {
    if (!_cover) {
        _cover =[[UIImageView alloc] initWithFrame:CGRectMake(0,0,itemW,itemW)];
        _cover.image =[UIImage imageNamed:@"wdsc_cnxh_02"];
    }
    return _cover;
}
-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.cover.frame),CGRectGetMaxY(self.cover.frame)+10,CGRectGetWidth(self.cover.frame),20)];
        [AppUtils getConfigueLabel:_titleLabel font:PingFangSCRegular14 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@""];
        _titleLabel.numberOfLines =0;

    }
    return _titleLabel;
}
-(UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame),CGRectGetMaxY(self.titleLabel.frame)+5,CGRectGetWidth(self.titleLabel.frame),10)];
        [AppUtils getConfigueLabel:_priceLabel font:PingFangSCRegular13 aliment:NSTextAlignmentLeft textcolor:RGB(239,89,60) text:@"￥299"];
    }
    return _priceLabel;
}
-(void)setList:(HKFrindShopList *)list {
        _list = list;
        self.titleLabel.text = list.title;
        [self.cover sd_setImageWithURL:[NSURL URLWithString:list.imgSrc] placeholderImage:[UIImage imageNamed:@"wdsc_cnxh_02"]];
        self.priceLabel.text =[NSString  stringWithFormat:@"￥%zd",list.price];
}

@end
