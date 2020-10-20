//
//  CemSingleGoodsCollectionViewCell.m
//  FamilyTree
//
//  Created by 王子豪 on 16/6/13.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "CemSingleGoodsCollectionViewCell.h"
@interface CemSingleGoodsCollectionViewCell()
@property (nonatomic,strong) UIImageView *headImage; /*图片*/
@property (nonatomic,strong) UILabel *nameLabel; /*图片名称*/
@property (nonatomic,strong) UILabel *priceLabel; /*价格*/

@property (nonatomic,strong) UIImageView *clicedImage; /*点击选中*/




@end
@implementation CemSingleGoodsCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.headImage];
        [self addSubview:self.nameLabel];
        [self addSubview:self.priceLabel];
        
        [self addSubview:self.clicedImage];
        if (_selectedItem) {
            self.clicedImage.hidden = false;
        }else{
            self.clicedImage.hidden = true;
        }
    }
    return self;
}

-(void)setCemGoodsShopModel:(CemGoodsShopModel *)cemGoodsShopModel{
    _cemGoodsShopModel = cemGoodsShopModel;
    [self.headImage setImageWithURL:[NSURL URLWithString:cemGoodsShopModel.CoCover] placeholder:MImage(@"my_name_flour")];
    self.nameLabel.text = cemGoodsShopModel.CoConame;
    if ([cemGoodsShopModel.CoConstype isEqualToString:@"JF"]) {
        self.priceLabel.text = [NSString stringWithFormat:@"%ld积分/天",(long)cemGoodsShopModel.CoprMoney];
    }else{
        self.priceLabel.text = [NSString stringWithFormat:@"%ld分/天",(long)cemGoodsShopModel.CoprMoney];
    }
}


#pragma mark *** getters ***

-(UIImageView *)headImage{
    if (!_headImage) {
        _headImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80*AdaptationWidth(), 80*AdaptationWidth())];
        _headImage.contentMode = UIViewContentModeScaleAspectFit;
        //_headImage.image = MImage(@"my_name_flour");
        _headImage.backgroundColor = [UIColor whiteColor];
    }
    return _headImage;
}
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectYH(self.headImage), 80*AdaptationWidth(), 32*AdaptationWidth())];
        _nameLabel.font = MFont(20*AdaptationWidth());
        //_nameLabel.text = @"百合花";
        _nameLabel.textAlignment = 1;
    }
    return _nameLabel;
}
-(UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectYH(self.nameLabel), 80*AdaptationWidth(), 20*AdaptationWidth())];
        _priceLabel.font = MFont(15*AdaptationWidth());
        //_priceLabel.text = @"2同城币/天";
        _priceLabel.textAlignment = 1;
    }
    return _priceLabel;
}
-(UIImageView *)clicedImage{
    if (!_clicedImage) {
        _clicedImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.headImage.bounds.size.width-20*AdaptationWidth()-2, 2, 20*AdaptationWidth(), 20*AdaptationWidth())];
        _clicedImage.image = MImage(@"ghg_ture");
    }
    return _clicedImage;
}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    _selectedItem = !_selectedItem;
    if (_selectedItem) {
        self.clicedImage.hidden = false;
    }else{
        self.clicedImage.hidden = true;
    }
}
@end
