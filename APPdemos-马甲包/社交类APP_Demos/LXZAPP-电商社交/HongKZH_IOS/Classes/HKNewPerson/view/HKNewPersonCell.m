//
//  HKNewPersonCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKNewPersonCell.h"

@interface HKNewPersonCell ()
//底部背景图
@property (nonatomic, strong)UIImageView *backIm;
//劵图标
@property (nonatomic, strong)UIImageView *conerV;
//折扣图标
@property (nonatomic, strong)UIImageView * cover;
//劵标题
@property (nonatomic, strong)UILabel * titleLabel;
//类型
@property (nonatomic, strong)UILabel * typeLabel;
//商品价格或有效期
@property (nonatomic, strong)UILabel *typeDetailLabel;
//虚线..
@property (nonatomic, strong)UIImageView * weakView;
//马上抢
@property (nonatomic, strong)UIButton *justUseBtn;
//乐币数量
@property (nonatomic, strong)UILabel * coinNumberLabel;
//乐币图标
@property (nonatomic, strong)UIImageView * coinV;
//售价
@property (nonatomic, strong)UILabel * buyPriceLabel;
//剩余数量
@property (nonatomic, strong)UILabel * leftLabel;
//进度底部条
@property (nonatomic, strong)UIView * progressBackView;
//当前进度条
@property (nonatomic, strong)UIView * stepView;

@end

@implementation HKNewPersonCell
{
    NSInteger _tag;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = UICOLOR_RGB_Alpha(0xf2f2f2, 1);
        [self.contentView addSubview:self.backIm];
        [self.backIm addSubview:self.cover];
        [self.backIm addSubview:self.conerV];
        [self.backIm addSubview:self.titleLabel];
        [self.backIm addSubview:self.typeLabel];
        [self.backIm addSubview:self.typeDetailLabel];
        [self.backIm addSubview:self.weakView];
        [self.backIm addSubview:self.justUseBtn];
        [self.backIm addSubview:self.coinNumberLabel];
        [self.backIm  addSubview:self.coinV];
        [self.backIm addSubview:self.buyPriceLabel];
        [self.backIm addSubview:self.leftLabel];
        [self.backIm addSubview:self.progressBackView];
        [self.backIm addSubview:self.stepView];
    }
    return  self;
}
-(UIImageView *)backIm {
    if (!_backIm) {
        _backIm =[[UIImageView alloc] initWithFrame:CGRectMake(15,10,kScreenWidth-30,150)];
        _backIm.image =[UIImage imageNamed:@"sy_js_bg"];
        _backIm.userInteractionEnabled =YES;
    }
    return _backIm;
}
-(UIImageView *)cover {
    if (!_cover) {
        _cover =[[UIImageView alloc] initWithFrame:CGRectMake(15,15,70,70)];
        _cover.contentMode = UIViewContentModeScaleAspectFill;
        _cover.layer.masksToBounds =YES;
    }
    return _cover;
}
-(UIImageView *)conerV {
    if (!_conerV) {
        UIImage * cor =[UIImage imageNamed:@"sy_5z"];
        _conerV =[[UIImageView alloc] initWithFrame:CGRectMake(0,0,cor.size.width,cor.size.height)];
        _conerV.hidden = YES;
    }
    return _conerV;
}

-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.cover.frame)+15,CGRectGetMinY(self.cover.frame)+10,CGRectGetWidth(self.backIm.frame)-CGRectGetMaxX(self.cover.frame)-30,15)];
        [AppUtils getConfigueLabel:_titleLabel font:PingFangSCMedium15 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@"88888"];
    }
    return _titleLabel;
}

-(UILabel *)typeLabel
{
    if (!_typeLabel) {
        _typeLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame),CGRectGetMaxY(self.titleLabel.frame)+8,38,16)];
        _typeLabel.layer.cornerRadius =3;
        _typeLabel.layer.masksToBounds = YES;
        _typeLabel.layer.borderWidth = 1;
        _typeLabel.layer.borderColor =[RGB(230,89,60) CGColor];
        [AppUtils getConfigueLabel:_typeLabel font:PingFangSCRegular10 aliment:NSTextAlignmentCenter textcolor:RGB(230,89,60) text:@"折扣劵"];
        
    }
    return _typeLabel;
}
-(UILabel *)typeDetailLabel {
    if (!_typeDetailLabel) {
        _typeDetailLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.typeLabel.frame),CGRectGetMaxY(self.typeLabel.frame)+10,300,10)];
        [AppUtils getConfigueLabel:_typeDetailLabel font:PingFangSCRegular12 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"999999"] text:@"商品原价: $172"];
    }
    return _typeDetailLabel;
}
//虚线...
-(UIImageView *)weakView {
    if (!_weakView) {
        UIImage * weakIm  =[UIImage imageNamed:@"yhq_fgx"];
        _weakView =[[UIImageView alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(self.cover.frame)+15,CGRectGetWidth(self.backIm.frame)-30,weakIm.size.height)];
        _weakView.image = weakIm;
    }
    
    return _weakView;
}
-(UILabel *)buyPriceLabel {
    if (!_buyPriceLabel) {
        _buyPriceLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.coinV.frame)-5-80,CGRectGetMinY(self.justUseBtn.frame),80,CGRectGetHeight(self.justUseBtn.frame))];
        [AppUtils getConfigueLabel:_buyPriceLabel font:PingFangSCRegular13 aliment:NSTextAlignmentRight textcolor:RGB(102,102,102) text:@"售价:"];
    }
    return _buyPriceLabel;
}
-(UIImageView *)coinV {
    if (!_coinV) {
        _coinV =[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.coinNumberLabel.frame)-5,CGRectGetMinY(self.justUseBtn.frame)+5,15,15)
                 ];
        _coinV.image =[UIImage imageNamed:@"sp_lb"];
    }
    return _coinV;
}
-(UILabel *)coinNumberLabel {
    if (!_coinNumberLabel) {
        _coinNumberLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.justUseBtn.frame)-10-17,CGRectGetMinY(self.justUseBtn.frame)+5.5,17,14)];
        [AppUtils getConfigueLabel:_coinNumberLabel font:PingFangSCRegular13 aliment:NSTextAlignmentRight textcolor:RGB(230,89,60) text:@"20"];
        
    }
    return _coinNumberLabel;
}
-(UIButton *)justUseBtn {
    if (!_justUseBtn) {
        _justUseBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _justUseBtn.frame =CGRectMake(CGRectGetWidth(self.backIm.frame)-15-65,CGRectGetMaxY(self.weakView.frame)+12,65,25);
        [AppUtils getButton:_justUseBtn font:PingFangSCRegular12 titleColor:RGB(230,89,60) title:@"马上抢"];
        _justUseBtn.layer.cornerRadius = 5;
        _justUseBtn.layer.masksToBounds = YES;
        _justUseBtn.layer.borderWidth =1;
        _justUseBtn.layer.borderColor =[RGB(230,89, 60) CGColor];
        _justUseBtn.backgroundColor =[UIColor whiteColor];
        _justUseBtn.tag = 3;
        [_justUseBtn addTarget:self action:@selector(SenderClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _justUseBtn;
}

-(UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.cover.frame),CGRectGetMaxY(self.weakView.frame)+10,120,12)];
        [AppUtils getConfigueLabel:_leftLabel font:PingFangSCRegular10 aliment:NSTextAlignmentLeft textcolor:RGB(153,153,153) text:@"剩余: 15张"];
    }
    return _leftLabel;
}

-(UIView *)progressBackView {
    if (!_progressBackView) {
        _progressBackView =[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.leftLabel.frame),CGRectGetMaxY(self.leftLabel.frame)+4,110,6)];
        _progressBackView.layer.cornerRadius=4;
        _progressBackView.backgroundColor = RGB(237,237,237);
    }
    return _progressBackView;
}
-(UIView *)stepView {
    if (!_stepView) {
        _stepView =[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.leftLabel.frame), CGRectGetMinY(self.progressBackView.frame),35,CGRectGetHeight(self.progressBackView.frame))];
        _stepView.layer.cornerRadius =4;
        _stepView.backgroundColor = keyColor;
    }
    return _stepView;
}
#pragma mark 点击事件
-(void)SenderClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(labelTagBlock:tag:)]) {
        [self.delegate labelTagBlock:self.list tag:_tag];
    }
}
-(void)setListModel:(HKNewPersonList *)list andTags:(NSInteger)tag {
    _list  =list;
    _tag = tag;
    [AppUtils seImageView:self.cover withUrlSting:list.imgSrc placeholderImage:nil];
    self.titleLabel.text = list.title;
    self.typeDetailLabel.text =[NSString stringWithFormat:@"商品原价: ￥%zd",list.pintegral];
    if (list.discount) {
        self.conerV.hidden = NO;
        self.conerV.image =[UIImage imageNamed:[NSString stringWithFormat:@"xrzx_%zdz",list.discount]];
    }else {
        self.conerV.hidden = YES;
    }
    //乐币数量
    NSString * coinStr =[NSString stringWithFormat:@"%.2lf",list.integral];
    CGRect rect =[coinStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX,CGRectGetHeight(self.coinNumberLabel.frame)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:PingFangSCRegular13,NSForegroundColorAttributeName:keyColor} context:nil];
    self.coinNumberLabel.frame = CGRectMake(CGRectGetMinX(self.justUseBtn.frame)-10-rect.size.width,self.coinNumberLabel.frame.origin.y,rect.size.width,self.coinNumberLabel.frame.size.height);
    self.coinV.frame =CGRectMake(CGRectGetMinX(self.coinNumberLabel.frame)-5-15,CGRectGetMinY(self.justUseBtn.frame)+5,15,15);
    self.buyPriceLabel.frame =CGRectMake(CGRectGetMinX(self.coinV.frame)-5-80,CGRectGetMinY(self.justUseBtn.frame),80,CGRectGetHeight(self.justUseBtn.frame));
    if (tag>=0) {
        self.progressBackView.hidden = NO;
        self.stepView.hidden = NO;
        //求stepV 宽度
        CGFloat stepW  = CGRectGetWidth(self.progressBackView.frame)*list.lastStocks / list.activityStocks;
        self.stepView.frame = CGRectMake(self.stepView.frame.origin.x,self.stepView.frame.origin.y,stepW,self.stepView.frame.size.height);
        self.leftLabel.frame =CGRectMake(CGRectGetMinX(self.cover.frame),CGRectGetMaxY(self.weakView.frame)+10,120,12);
       [AppUtils getConfigueLabel:self.leftLabel font:PingFangSCRegular10 aliment:NSTextAlignmentLeft textcolor:RGB(153,153,153) text:@""];
        self.leftLabel.text =[NSString stringWithFormat:@"剩余: %zd张",self.list.lastStocks];
        self.justUseBtn.layer.borderColor =[keyColor CGColor];
        [self.justUseBtn setTitle:@"马上抢" forState:UIControlStateNormal];
        [self.justUseBtn setTitleColor:keyColor forState:UIControlStateNormal];
        
    }else {
        self.progressBackView.hidden = YES;
        self.stepView.hidden = YES;
        self.leftLabel.frame = CGRectMake(self.leftLabel.frame.origin.x,CGRectGetMinY(self.justUseBtn.frame),120,CGRectGetHeight(self.justUseBtn.frame));
        [AppUtils getConfigueLabel:self.leftLabel font:PingFangSCRegular13 aliment:NSTextAlignmentLeft textcolor:RGB(153,153,153) text:@""];
        self.leftLabel.text =[NSString stringWithFormat:@"总计: %zd张",self.list.activityStocks];
        self.justUseBtn.layer.borderColor =[RGB(204,204,204) CGColor];
        [self.justUseBtn setTitle:@"即将开始" forState:UIControlStateNormal];
        [self.justUseBtn setTitleColor:[UIColor colorFromHexString:@"666666"] forState:UIControlStateNormal];
    }
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
