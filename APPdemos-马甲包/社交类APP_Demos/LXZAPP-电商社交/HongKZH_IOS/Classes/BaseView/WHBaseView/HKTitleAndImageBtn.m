//
//  HKTitleAndImageBtn.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/14.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKTitleAndImageBtn.h"
@interface HKTitleAndImageBtn()
@property (nonatomic, strong)UIImageView *iconView;
@property (nonatomic, strong)UILabel *title;
@end

@implementation HKTitleAndImageBtn
-(void)awakeFromNib{
    [super awakeFromNib];
    [self setUI];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
       [self setUI];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}
-(void)setUI{
    [self addSubview:self.title];
    [self addSubview:self.iconView];
    UIButton *btn = [[UIButton alloc]init];
    [self addSubview:btn];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.centerX.equalTo(self).offset(-5);
    }];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.title.mas_right).offset(5);
//        make.width.height.mas_equalTo(5);
    }];
}
-(UILabel *)title{
    if (!_title) {
        _title = [[UILabel alloc]init];
        _title.font = [UIFont systemFontOfSize:12];
        _title.textColor = [UIColor colorWithRed:124.0/255.0 green:124.0/255.0 blue:124.0/255.0 alpha:1];
    }
    return _title;
}
-(UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc]init];
    }
    return _iconView;
}
-(void)setBackgroundColor:(UIColor *)backgroundColor title:(NSString*)title imageName:(NSString*)imageName{
    self.backgroundColor = backgroundColor;
    self.title.text = title;
    self.iconView.image = [UIImage imageNamed:imageName];
}
-(void)setBackgroundColor:(UIColor *)backgroundColor title:(NSString*)title imageName:(NSString*)imageName cornerRadius:(CGFloat)cornerRadius{
    self.backgroundColor = backgroundColor;
    self.title.text = title;
    self.iconView.image = [UIImage imageNamed:imageName];
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}
-(void)btnClick{
    if ([self.delegate respondsToSelector:@selector(btnClick:)]) {
        [self.delegate btnClick:self];
    }
}
@end
