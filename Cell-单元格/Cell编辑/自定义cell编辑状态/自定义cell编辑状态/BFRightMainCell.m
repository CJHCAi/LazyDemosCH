//
//  BFRightMainCell.m
//  自定义cell编辑状态
//
//  Created by bxkj on 2017/8/3.
//  Copyright © 2017年 周冰烽. All rights reserved.
//

#import "BFRightMainCell.h"
#import "Masonry.h"
#import "UIColor+BFColor.h"
@interface BFRightMainCell()

@property(nonatomic,weak) UIView *borderLine;

@property(nonatomic,weak) UIView *borderView;

@property(nonatomic,assign) NSInteger moveNum;

@end

@implementation BFRightMainCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    [self setupLeftSelectView];
    //商铺图片
    [self setupShopsImage];
    //商铺名称
    [self setupShopsName];
    //商铺会员标志
    [self setupIsVipBtn];
    //商铺主营
    [self setupShopsSales];
    //底部横线
    [self setupBottomLine];
}

- (void)setupShopsImage{
    UIImageView *imageView = [[UIImageView alloc]init];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.borderLine.mas_right).offset(16);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(@134);
        make.height.mas_equalTo(@90);
    }];
    self.shopImageView = imageView;
}

- (void)setupShopsName{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:16.0f];
    label.textColor = [UIColor BF_ColorWithHex:0x191919];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shopImageView.mas_right).offset(16);
        make.top.equalTo(self).offset(16);
    }];
    self.shopName = label;
}

- (void)setupIsVipBtn{
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitleColor:[UIColor BF_ColorWithHex:0x319BF5] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shopImageView.mas_right).offset(16);
        make.top.equalTo(self.shopName.mas_bottom).offset(6);
        make.width.mas_equalTo(@83);
        make.height.mas_equalTo(@21);
    }];
    self.isVipBtn = btn;
}

- (void)setupShopsSales{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:12.0f];
    label.textColor = [UIColor BF_ColorWithHex:0xA1A1A1];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shopImageView.mas_right).offset(16);
        make.top.equalTo(self.isVipBtn.mas_bottom).offset(15);
    }];
    self.shopSales = label;
}

- (void)setupBottomLine{
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor BF_ColorWithHex:0xEFEFEF];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self);
        make.left.equalTo(self).offset(-50);
        make.height.mas_equalTo(@1);
    }];
}
- (void)setupLeftSelectView{
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor BF_ColorWithHex:0xEFEFEF];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.mas_left);
        make.width.mas_equalTo(@1);
    }];
    self.borderLine = line;
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.borderLine.mas_left);
        make.top.equalTo(self);
        make.bottom.equalTo(self).offset(-1);
        make.width.mas_equalTo(50);
    }];
    self.borderView = view;
    UIButton *btn = [[UIButton alloc]init];
    [btn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
    [view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.centerY.equalTo(view);
    }];
    self.collectBtn = btn;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    if (editing) {
        [self customMultipleChioce];
    }else{
        [self customMultiple];
    }
}
-(void)customMultipleChioce{
    self.moveNum = 50;
    [self updateMasonry];
    [UIView animateWithDuration:0.5 animations:^{
        [self layoutIfNeeded];
    }];
}
-(void)customMultiple{
    self.moveNum = 0;
    [self updateMasonry];
    [UIView animateWithDuration:0.5 animations:^{
        [self layoutIfNeeded];
    }];
}
- (void)updateMasonry{
    [self.borderLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.mas_left).offset(self.moveNum);
        make.width.mas_equalTo(@1);
    }];
    
}


@end
