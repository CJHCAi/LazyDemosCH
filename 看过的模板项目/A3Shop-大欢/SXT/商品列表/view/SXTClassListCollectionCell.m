//
//  SXTClassListCollectionCell.m
//  SXT
//
//  Created by 赵金鹏 on 16/8/29.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import "SXTClassListCollectionCell.h"
#import <UIImageView+WebCache.h>
@interface SXTClassListCollectionCell()

@property (strong, nonatomic)   UIImageView *countryImage;              /** 国旗 */
@property (strong, nonatomic)   UIImageView *goodsImage;              /** 商品图片 */
@property (strong, nonatomic)   UILabel *titleLabel;              /** 商品标题 */
@property (strong, nonatomic)   UILabel *priceLabel;              /** 价格label */

@end

@implementation SXTClassListCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.countryImage];
        [self addSubview:self.goodsImage];
        [self addSubview:self.titleLabel];
        [self addSubview:self.priceLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    __weak typeof (self) weakSelf = self;
    [_goodsImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf).with.insets(UIEdgeInsetsMake(0, 0, 80, 0));
    }];
    
    [_countryImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).offset(11);
        make.left.equalTo(weakSelf.mas_left).offset(11);
        make.size.mas_equalTo(CGSizeMake(22, 16));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.goodsImage.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.mas_left).offset(11);
        make.right.equalTo(weakSelf.mas_right).offset(-11);
        make.height.equalTo(@40);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(11);
        make.right.equalTo(weakSelf.mas_right).offset(-11);
        make.height.equalTo(@23);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(5);
    }];
    
}

- (void)setClassModel:(SXTClassListViewModel *)classModel{
    _classModel = classModel;
    [_countryImage sd_setImageWithURL:[NSURL URLWithString:classModel.CountryImg]];
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:classModel.ImgView]];
    _titleLabel.text = classModel.Abbreviation;
    [self priceAttributedString];
}
- (void)priceAttributedString{
    
    //当前价格(需要手动添加人民币符号)
    NSString *nowPrice = [NSString stringWithFormat:@"¥%@ ",_classModel.Price];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:nowPrice attributes:@{NSForegroundColorAttributeName:RGB(230, 51, 37),
                                                                                                               NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0]}];
    //过去价格
    NSString *oldString = [NSString stringWithFormat:@"%@ ",_classModel.DomesticPrice];
    NSMutableAttributedString *oldPrice = [[NSMutableAttributedString alloc]initWithString:oldString attributes:@{NSForegroundColorAttributeName:RGB(132, 132, 132),NSFontAttributeName:[UIFont systemFontOfSize:12.0],
                                                                                                                  NSStrikethroughStyleAttributeName:@(2)}];
    [string insertAttributedString:oldPrice atIndex:string.length];
    _priceLabel.attributedText = string;
}
- (UIImageView *)countryImage{
    if (!_countryImage) {
        _countryImage = [[UIImageView alloc]init];
    }
    return _countryImage;
}

- (UIImageView *)goodsImage{
    if (!_goodsImage) {
        _goodsImage = [[UIImageView alloc]init];
    }
    return _goodsImage;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.numberOfLines = 2;
        _titleLabel.font = [UIFont systemFontOfSize:15.0];
    }
    return _titleLabel;
}

- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc]init];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _priceLabel;
}

@end
