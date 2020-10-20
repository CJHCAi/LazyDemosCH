//
//  BFLeftMainCell.m
//  自定义cell编辑状态
//
//  Created by bxkj on 2017/8/3.
//  Copyright © 2017年 周冰烽. All rights reserved.
//

#import "BFLeftMainCell.h"
#import "Masonry.h"
#import "UIColor+BFColor.h"
@interface BFLeftMainCell()

@property(nonatomic,weak) UIView *borderLine;

@property(nonatomic,weak) UIView *imageViewBorder;

@property(nonatomic,weak) UIView *borderView;

@property(nonatomic,assign) NSInteger moveNum;

@end

@implementation BFLeftMainCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    //左侧选择按钮
    [self setupLeftSelectView];
    //商品图片外边框
    [self setupImageViewBorder];
    //商品图片
    [self setupGoodsImage];
    //标题
    [self setupGoodsTitle];
    //地点
    [self setupAddress];
    //价格
    [self setupPrice];
    //标志
    [self setupTips];
    //底部横线
    [self setupBottomLine];
    
}

- (void)setupImageViewBorder{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor BF_ColorWithHex:0xF0F0F0];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.borderLine.mas_right).offset(20);
        make.centerY.equalTo(self);
        make.height.width.mas_equalTo(@90);
    }];
    self.imageViewBorder = view;
}

- (void)setupGoodsImage{
    UIImageView *imageView = [[UIImageView alloc]init];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.borderLine.mas_right).offset(25);
        make.centerY.equalTo(self);
        make.height.width.mas_equalTo(@80);
    }];
    self.goodsImageView = imageView;
}

- (void)setupGoodsTitle{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textColor = [UIColor blackColor];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(21);
        make.left.equalTo(self.goodsImageView.mas_right).offset(11);
    }];
    self.goodsTitle = label;
}

- (void)setupAddress{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:12.0f];
    label.textColor = [UIColor BF_ColorWithHex:0xA1A1A1];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsImageView.mas_right).offset(11);
        make.top.equalTo(self.goodsTitle.mas_bottom).offset(13);
    }];
    self.address = label;
}

- (void)setupPrice{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textColor = [UIColor BF_ColorWithHex:0xF77676];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsImageView.mas_right).offset(11);
        make.top.equalTo(self.address.mas_bottom).offset(2);
    }];
    self.goodsPrice = label;
}

- (void)setupTips{
    UIImageView *imageView = [[UIImageView alloc]init];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-24);
        make.bottom.equalTo(self).offset(-12);
        make.height.with.mas_equalTo(@30);
    }];
    self.tipImageView = imageView;
}

- (void)setupBottomLine{
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor BF_ColorWithHex:0xEFEFEF];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self);
        make.left.equalTo(self).offset(23);
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
    [self.tipImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-24+self.moveNum);
        make.bottom.equalTo(self).offset(-12);
        make.height.with.mas_equalTo(@30);
    }];
    [self.borderLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.mas_left).offset(self.moveNum);
        make.width.mas_equalTo(@1);
    }];
    
}


@end
