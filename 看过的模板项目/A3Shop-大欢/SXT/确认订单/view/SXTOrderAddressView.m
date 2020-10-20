//
//  SXTOrderAddressView.m
//  SXT
//
//  Created by 赵金鹏 on 16/8/30.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import "SXTOrderAddressView.h"

@interface SXTOrderAddressView()
@property (strong, nonatomic)   UILabel *addressLabel;/**地址信息*/
@property (strong, nonatomic)   UILabel *phoneLabel;/**电话号码*/
@property (strong, nonatomic)   UIImageView *addressImage;/**地址图标*/
@property (strong, nonatomic)   UIButton *backButton;/**背景button*/
@end

@implementation SXTOrderAddressView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backButton];
        [self addSubview:self.addressImage];
        [self addSubview:self.addressLabel];
        [self addSubview:self.phoneLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    __weak typeof (self) weakSelf = self;
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [_addressImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.left.equalTo(weakSelf.mas_left).offset(8);
    }];
    
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).offset(10);
        make.left.equalTo(weakSelf.addressImage.mas_right).offset(10);
        make.right.equalTo(weakSelf.mas_right).offset(-10);
        make.height.equalTo(@30);
    }];
    
    [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.addressImage.mas_right).offset(10);
        make.right.equalTo(weakSelf.mas_right).offset(-10);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-10);
        make.height.equalTo(@15);
    }];
}

- (UIImageView *)addressImage{
    if (!_addressImage) {
        _addressImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"位置"]];
    }
    return _addressImage;
}

- (UILabel *)addressLabel{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc]init];
        _addressLabel.text = @"天通苑东三旗旧货市场";
        _addressLabel.textColor = [UIColor grayColor];
        _addressLabel.font = [UIFont systemFontOfSize:13.0];
    }
    return _addressLabel;
}

- (UILabel *)phoneLabel{
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc]init];
        _phoneLabel.text = @"17721025593";
        _phoneLabel.textColor = [UIColor grayColor];
        _phoneLabel.font = [UIFont systemFontOfSize:13.0];
    }
    return _phoneLabel;
}

- (UIButton *)backButton{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_backButton setImage:[UIImage imageNamed:@"地址背景"] forState:(UIControlStateNormal)];
    }
    return _backButton;
}

@end







