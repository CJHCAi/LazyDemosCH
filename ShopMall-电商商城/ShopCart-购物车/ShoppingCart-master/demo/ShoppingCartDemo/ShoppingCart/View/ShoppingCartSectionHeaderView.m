//
//  ShoppingCartSectionHeaderView.m
//  ShoppingCartDemo
//
//  Created by dry on 2017/12/6.
//  Copyright © 2017年 MorrisMeng. All rights reserved.
//

#import "ShoppingCartSectionHeaderView.h"
#import "ShoppingCartModel.h"

@interface ShoppingCartSectionHeaderView ()
{
    DDButton *_selectBtn;
    UIImageView *_shopImageView;
    DDLabel *_shopTitleLabel;
}
@end

@implementation ShoppingCartSectionHeaderView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _selectBtn.frame = CGRectMake(10, self.height*0.5-16, 32, 32);
    _shopImageView.frame = CGRectMake(_selectBtn.toLeftMargin+10, self.height*0.5-14, 28, 28);
    _shopTitleLabel.frame = CGRectMake(_shopImageView.toLeftMargin+10, 0, kScreenWidth-(_shopImageView.toLeftMargin+20), self.height);
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _selectBtn = [DDButton buttonWithType:UIButtonTypeCustom];
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"list_unchoose"] forState:UIControlStateNormal];
        [_selectBtn addTarget:self action:@selector(selectedAll:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_selectBtn];
        
        _shopImageView = [[UIImageView alloc] init];
        _shopImageView.image = [UIImage imageNamed:@"shopImage"];
        [self.contentView addSubview:_shopImageView];

        _shopTitleLabel = [[DDLabel alloc] init];
        _shopTitleLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:_shopTitleLabel];
    }
    return self;
}

- (void)selectedAll:(UIButton *)btn {
    btn.selected = !btn.selected;
    [self setSelectedBtnImg:btn.selected];
    
    if ([self.delegate respondsToSelector:@selector(hearderView:isSelected:section:)]) {
        [self.delegate hearderView:self isSelected:btn.selected section:self.section];
    }
}
- (void)setSelectedBtnImg:(BOOL)slected {
    if (slected) {
        [_selectBtn setImage:ImgName(@"list_choose") forState:(UIControlStateNormal)];
    } else {
        [_selectBtn setImage:ImgName(@"list_unchoose") forState:(UIControlStateNormal)];
    }
}

- (void)setInfo:(ShopModel *)shopModel {
    _shopTitleLabel.text = shopModel.shopName;
    _selectBtn.selected = shopModel.isSelected;
    [self setSelectedBtnImg:_selectBtn.selected];
}

@end
