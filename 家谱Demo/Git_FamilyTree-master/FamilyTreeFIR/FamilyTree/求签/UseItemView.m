//
//  UseItemView.m
//  FamilyTree
//
//  Created by 王子豪 on 16/6/20.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "UseItemView.h"

@interface UseItemView()
@property (nonatomic,strong) UIView *halfBlackView; /*背景半透明图*/
@property (nonatomic,strong) UIImageView *divinView; /*具体道具详情*/


@end

@implementation UseItemView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.halfBlackView];
        [self addSubview:self.divinView];
        
        [self.divinView addSubview:self.useBtn];
        [self.divinView addSubview:self.priceLabel];
        [self.divinView addSubview:self.goodsImage];
        
    }
    return self;
}
#pragma mark *** GesEvent ***
-(void)respondsToTapGes{
    
    [self removeFromSuperview];
    
}
/** 点击了试用 */
-(void)respondsToUseBtn:(UIButton *)sender{
    MYLog(@"试用");
    [self removeFromSuperview];
    if (_delegate && [_delegate respondsToSelector:@selector(UseItemViewDidRespondsToUseBtn:)]) {
        [_delegate UseItemViewDidRespondsToUseBtn:self];
    }
}
#pragma mark *** getters ***
-(UIView *)halfBlackView{
    if (!_halfBlackView) {
        _halfBlackView = [[UIView alloc] initWithFrame:self.bounds];
        _halfBlackView.backgroundColor = [UIColor blackColor];
        _halfBlackView.alpha = 0.7;
        _halfBlackView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGus = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTapGes)];
        [_halfBlackView addGestureRecognizer:tapGus];
        
    }
    return _halfBlackView;
}
-(UIImageView *)divinView{
    if (!_divinView) {
        _divinView = [[UIImageView alloc] initWithFrame:AdaptationFrame(34, 150, 660, 737)];
        _divinView.userInteractionEnabled = YES;
        _divinView.image = MImage(@"qq_add_sl");
        
    }
    return _divinView;
}
-(UIButton *)useBtn{
    if (!_useBtn) {
        _useBtn = [[UIButton alloc] initWithFrame:AdaptationFrame(84, 556, 500, 65)];
        _useBtn.layer.cornerRadius = 2;
        _useBtn.clipsToBounds = YES;
        [_useBtn setTitle:@"试用" forState:0];
        [_useBtn addTarget:self action:@selector(respondsToUseBtn:) forControlEvents:UIControlEventTouchUpInside];
        _useBtn.backgroundColor = LH_RGBCOLOR(74, 88, 91);
        
    }
    return _useBtn;
}
-(UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:AdaptationFrame(231, 324, 236, 45)];
        _priceLabel.font = WFont(45);
        _priceLabel.text = @"5元/天";
        _priceLabel.textAlignment = 1;
        
    }
    return _priceLabel;
}
-(UIImageView *)goodsImage{
    if (!_goodsImage) {
        _goodsImage = [[UIImageView alloc] initWithFrame:AdaptationFrame(120, 123, 105, 75)];
//        _goodsImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _goodsImage;
}
@end
