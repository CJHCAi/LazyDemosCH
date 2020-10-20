//
//  SXTBuyCarListCell.m
//  SXT
//
//  Created by 赵金鹏 on 16/8/30.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import "SXTBuyCarListCell.h"
#import <UIImageView+WebCache.h>
@interface SXTBuyCarListCell()
@property (strong, nonatomic)   UILabel *titleLabel;              /** 商品名字 */
@property (strong, nonatomic)   UILabel *priceLabel;              /** 价格 */
@property (strong, nonatomic)   UILabel *goodsNumLabel;              /** 商品个数 */

@property (strong, nonatomic)   UIImageView*iconImage;              /** 商品介绍图片 */
@property (strong, nonatomic)   UIImageView *backImage;              /** 加减背景图片 */
@end
@implementation SXTBuyCarListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.priceLabel];
        [self addSubview:self.goodsNumLabel];
        [self addSubview:self.isSelectBtn];
        [self addSubview:self.addButton];
        [self addSubview:self.cutButton];
        [self addSubview:self.iconImage];
        [self addSubview:self.backImage];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    __weak typeof (self) weakSelf = self;
    [_isSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(21, 21));
        make.left.equalTo(weakSelf.mas_left).offset(15);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(53, 53));
        make.left.equalTo(weakSelf.isSelectBtn.mas_right).offset(8);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@14);
        make.left.equalTo(weakSelf.iconImage.mas_right).offset(18);
        make.right.equalTo(weakSelf.mas_right).offset(-20);
        make.top.equalTo(weakSelf.iconImage.mas_top);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@13);
        make.left.equalTo(weakSelf.iconImage.mas_right).offset(18);
        make.right.equalTo(weakSelf.backImage.mas_left).offset(-20);
        make.bottom.equalTo(weakSelf.iconImage.mas_bottom).offset(-7);
    }];
    
    [_backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(85, 25));
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-15);
        make.right.equalTo(weakSelf.mas_right).offset(-17);
    }];
    
    [_cutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.left.top.equalTo(weakSelf.backImage);
    }];
    
    [_addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.right.top.equalTo(weakSelf.backImage);
    }];
    
    [_goodsNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(weakSelf.backImage);
        make.width.equalTo(@35);
        make.centerX.equalTo(weakSelf.backImage.mas_centerX);
    }];
}

- (void)setCellData:(SXTBuyCarListModel *)cellData{
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:cellData.ImgView]];
    _titleLabel.text = cellData.GoodsTitle;
    _priceLabel.text = [NSString stringWithFormat:@"%.2lf",cellData.Price];
    _goodsNumLabel.text = [NSString stringWithFormat:@"%li",cellData.GoodsCount];
    _isSelectBtn.selected = cellData.isSelectButton;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:13.0];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.text = @"赏评";
    }
    return _titleLabel;
}

- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc]init];
        _priceLabel.font = [UIFont systemFontOfSize:13.0];
        _priceLabel.textColor = [UIColor blackColor];
        _priceLabel.text = @"¥241";
    }
    return _priceLabel;
}

- (UILabel *)goodsNumLabel{
    if (!_goodsNumLabel) {
        _goodsNumLabel = [[UILabel alloc]init];
        _goodsNumLabel.font = [UIFont systemFontOfSize:12.0];
        _goodsNumLabel.textAlignment = NSTextAlignmentCenter;
        _goodsNumLabel.text = @"12";
    }
    return _goodsNumLabel;
}

- (UIButton *)isSelectBtn{
    if (!_isSelectBtn ) {
        _isSelectBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_isSelectBtn setImage:[UIImage imageNamed:@"购物车界面商品选中对号按钮"] forState:(UIControlStateSelected)];
        [_isSelectBtn setImage:[UIImage imageNamed:@"购物车界面商品未选中"] forState:(UIControlStateNormal)];
    }
    return _isSelectBtn;
}

- (UIButton *)addButton{
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _addButton.backgroundColor = [UIColor clearColor];
    }
    return _addButton;
}

- (UIButton *)cutButton{
    if (!_cutButton) {
        _cutButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _cutButton.backgroundColor = [UIColor clearColor];
    }
    return _cutButton;
}

- (UIImageView *)iconImage{
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc]init];
    }
    return _iconImage;
}

- (UIImageView *)backImage{
    if (!_backImage) {
        _backImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"购物车界面商品加减按钮"]];
    }
    return _backImage;
}

@end














