//
//  ShoppingCartCell.m
//  ShoppingCartDemo
//
//  Created by dry on 2017/12/5.
//  Copyright © 2017年 MorrisMeng. All rights reserved.
//

#import "ShoppingCartCell.h"
#import "ShoppingCartModel.h"
#import <UIImageView+WebCache.h>

@interface ShoppingCartCell ()
{
    DDButton *_selectBtn;
    UIImageView *_goodsImageView;
    DDLabel *_goodNameLabel;
    DDLabel *_priceLabel;
}
@end

@implementation ShoppingCartCell

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _selectBtn.frame = CGRectMake(10, self.height*0.5-16, 32, 32);
    _goodsImageView.frame = CGRectMake(_selectBtn.toLeftMargin+10, 10, self.height-20, self.height-20);
    _goodNameLabel.frame = CGRectMake(_goodsImageView.toLeftMargin+8, 16, kScreenWidth-_goodsImageView.toLeftMargin-80, 16);
    _priceLabel.frame = CGRectMake(_goodNameLabel.origin_x, _goodNameLabel.toTopMargin+16, _goodNameLabel.width, _goodNameLabel.height);
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _selectBtn = [DDButton buttonWithType:UIButtonTypeCustom];
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"list_unchoose"] forState:UIControlStateNormal];
        [_selectBtn addTarget:self action:@selector(selectedGoods:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_selectBtn];

        _goodsImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_goodsImageView];
        
        _goodNameLabel = [[DDLabel alloc] init];
        [self.contentView addSubview:_goodNameLabel];
        
        _priceLabel = [[DDLabel alloc] init];
        [self.contentView addSubview:_priceLabel];
    }
    return self;
}

- (void)selectedGoods:(UIButton *)btn {
    _select = !_select;
    UIImage *selectBtnImage = (_select)?(ImgName(@"list_choose")):(ImgName(@"list_unchoose"));
    [_selectBtn setBackgroundImage:selectBtnImage forState:UIControlStateNormal];
    
    if ([self.delegate respondsToSelector:@selector(cell:selected:indexPath:)]) {
        [self.delegate cell:self selected:_select indexPath:self.indexPath];
    }
}

- (void)setInfo:(GoodsModel *)goodsModel {
    
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:goodsModel.imageUrl] placeholderImage:[UIImage imageNamed:@"shopCart"]];
    
    _select = goodsModel.isSelected;
    UIImage *selectBtnImage = _select?(ImgName(@"list_choose")):(ImgName(@"list_unchoose"));
    [_selectBtn setBackgroundImage:selectBtnImage forState:UIControlStateNormal];

    _goodNameLabel.text = goodsModel.goodsName;
    
    _priceLabel.text = goodsModel.price;
}

@end
