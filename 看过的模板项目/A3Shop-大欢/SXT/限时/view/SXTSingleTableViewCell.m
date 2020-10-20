//
//  SXTSingleTableViewCell.m
//  SXT
//
//  Created by 赵金鹏 on 16/8/22.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import "SXTSingleTableViewCell.h"
#import <UIImageView+WebCache.h>
@interface SXTSingleTableViewCell()

@property (strong, nonatomic)   UIImageView *iconImage;              /** 图片 */
@property (strong, nonatomic)   UIImageView *countryImage;              /** 国旗 */
@property (strong, nonatomic)   UILabel *titleLabel;              /** 标题label */
@property (strong, nonatomic)   UILabel *contentLabel;              /** 内容 */
@property (strong, nonatomic)   UILabel *pricLabel;              /** 价格label */
@property (strong, nonatomic)   UIButton *buyCarBtn;              /** 购物车按钮 */


@end

@implementation SXTSingleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.iconImage];
        [self addSubview:self.countryImage];
        [self addSubview:self.titleLabel];
        [self addSubview:self.contentLabel];
        [self addSubview:self.pricLabel];
        [self addSubview:self.buyCarBtn];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    __weak typeof (self) weakSelf = self;
    
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(140, 140));
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.left.equalTo(weakSelf.mas_left).offset(5);
    }];
    
    [_countryImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25, 20));
        make.left.equalTo(weakSelf.iconImage.mas_left).offset(8);
        make.top.equalTo(weakSelf.iconImage.mas_top).offset(8);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right).offset(-15);
        make.left.equalTo(weakSelf.iconImage.mas_right).offset(6);
        make.top.equalTo(weakSelf.mas_top).offset(25);
        make.height.equalTo(@15);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(7);
        make.right.equalTo(weakSelf.mas_right).offset(-15);
        make.left.equalTo(weakSelf.iconImage.mas_right).offset(6);
        make.height.equalTo(@60);
    }];
    
    [_pricLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@15);
        make.left.equalTo(weakSelf.iconImage.mas_right).offset(6);
        make.right.equalTo(weakSelf.buyCarBtn.mas_left).offset(-20);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-23);
    }];
    
    [_buyCarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(37, 37));
        make.right.equalTo(weakSelf.mas_right).offset(-45);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-20);
    }];
}

- (void)setSingleModel:(SXTSingleListModel *)singleModel{
    _singleModel = singleModel;
    _titleLabel.text = singleModel.Title;
    _contentLabel.text = singleModel.GoodsIntro;
    [_countryImage sd_setImageWithURL:[NSURL URLWithString:singleModel.CountryImg]];
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:singleModel.ImgView]];
//    _pricLabel.text = [NSString stringWithFormat:@"¥%@%@",singleModel.DomesticPrice,singleModel.Price];
    [self priceAttributedString];
}

- (void)priceAttributedString{
    
    //当前价格(需要手动添加人民币符号)
    NSString *nowPrice = [NSString stringWithFormat:@"¥%@ ",_singleModel.DomesticPrice];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:nowPrice attributes:@{NSForegroundColorAttributeName:RGB(230, 51, 37),
                                                                                                               NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0]}];
    //过去价格
    NSString *oldString = [NSString stringWithFormat:@"%@ ",_singleModel.Price];
    NSMutableAttributedString *oldPrice = [[NSMutableAttributedString alloc]initWithString:oldString attributes:@{NSForegroundColorAttributeName:RGB(132, 132, 132),NSFontAttributeName:[UIFont systemFontOfSize:12.0],
                                                                                                                           NSStrikethroughStyleAttributeName:@(2)}];
    [string insertAttributedString:oldPrice atIndex:string.length];
    _pricLabel.attributedText = string;
}

- (UIImageView *)iconImage{
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc]init];
    }
    return _iconImage;
}

- (UIImageView *)countryImage{
    if (!_countryImage) {
        _countryImage = [[UIImageView alloc]init];
    }
    return _countryImage;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
        _titleLabel.textColor = RGB(81, 81, 81);
    }
    return _titleLabel;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.textColor = RGB(35, 35, 35);
        _contentLabel.font = [UIFont systemFontOfSize:13.0];
        _contentLabel.numberOfLines = 3;
    }
    return _contentLabel;
}

- (UILabel *)pricLabel{
    if (!_pricLabel) {
        _pricLabel = [[UILabel alloc]init];
    }
    return _pricLabel;
}

- (UIButton *)buyCarBtn{
    if (!_buyCarBtn) {
        _buyCarBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_buyCarBtn setImage:[UIImage imageNamed:@"限时特卖界面购物车图标"] forState:(UIControlStateNormal)];
    }
    return _buyCarBtn;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
