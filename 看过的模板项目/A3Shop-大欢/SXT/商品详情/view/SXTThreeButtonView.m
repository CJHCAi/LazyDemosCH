//
//  SXTThreeButtonView.m
//  SXT
//
//  Created by 赵金鹏 on 16/8/24.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import "SXTThreeButtonView.h"

@interface SXTThreeButtonView()
@property (strong, nonatomic)   UIButton *buyCarbtn;              /** 购物车按钮 */
@property (strong, nonatomic)   UIButton *addBuyCarbtn;              /** 加入购物车 */
@property (strong, nonatomic)   UIButton *buyNowBtn;              /** 立即购买 */
@property (strong, nonatomic)   UIImageView *backImage;              /** 背景图 */
@end

@implementation SXTThreeButtonView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backImage];
        [self addSubview:self.buyCarbtn];
        [self addSubview:self.addBuyCarbtn];
        [self addSubview:self.buyNowBtn];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    __weak typeof (self) weakSelf = self;
    [_backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [_buyCarbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(26, 26));
        make.left.equalTo(weakSelf.mas_left).offset(13);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    
    [_addBuyCarbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.height.equalTo(@70);
        make.left.equalTo(weakSelf.buyCarbtn.mas_right).offset(35);
        make.right.equalTo(weakSelf.buyNowBtn.mas_left).offset(30);
    }];
    
    [_buyNowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.height.equalTo(@70);
        make.width.equalTo(weakSelf.addBuyCarbtn.mas_width);
        make.right.equalTo(weakSelf.mas_right).offset(-15);
    }];
    
    
    
}

- (UIImageView *)backImage{
    if (!_backImage) {
        _backImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tabbar_back"]];
    }
    return _backImage;
}

- (UIButton *)buyCarbtn{
    if (!_buyCarbtn) {
        _buyCarbtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_buyCarbtn setImage:[UIImage imageNamed:@"详情界面购物车按钮"] forState:(UIControlStateNormal)];
    }
    return _buyCarbtn;
}

- (UIButton *)addBuyCarbtn{
    if (!_addBuyCarbtn) {
        _addBuyCarbtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_addBuyCarbtn setImage:[UIImage imageNamed:@"详情界面加入购物车按钮"] forState:(UIControlStateNormal)];
        [_addBuyCarbtn addTarget:self action:@selector(addGoodsInBuyCar) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _addBuyCarbtn;
}

- (UIButton *)buyNowBtn{
    if (!_buyNowBtn) {
        _buyNowBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_buyNowBtn setImage: [UIImage imageNamed:@"详情界面立即购买按钮"] forState:(UIControlStateNormal)];
    }
    return _buyNowBtn;
}


- (void)addGoodsInBuyCar{
    if (_addBlock) {
        _addBlock();
    }
}
@end










