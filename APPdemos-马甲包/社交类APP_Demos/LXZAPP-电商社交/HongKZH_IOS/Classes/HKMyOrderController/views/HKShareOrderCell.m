//
//  HKShareOrderCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/15.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKShareOrderCell.h"

@interface HKShareOrderCell ()
//折扣图标
@property (nonatomic, strong)UIImageView *conerV;
//底部背景图
@property (nonatomic, strong)UIImageView *backIm;
//商品图标
@property (nonatomic, strong)UIImageView * cover;
//商品标题
@property (nonatomic, strong)UILabel * titleLabel;
//类型
@property (nonatomic, strong)UILabel * typeLabel;
//商品价格或有效期
@property (nonatomic, strong)UILabel *typeDetailLabel;
//虚线..
@property (nonatomic, strong)UIImageView * weakView;
//乐币数量
@property (nonatomic, strong)UILabel * coinNumberLabel;
//乐币图标
@property (nonatomic, strong)UIImageView * coinIM;
//实付款
@property (nonatomic, strong)UILabel * buyPriceLabel;
//邀请好友
@property (nonatomic, strong)UIButton *justUseBtn;
//取消订单
@property (nonatomic, strong)UIButton *shopBtn;
@end

@implementation HKShareOrderCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = MainColor;
        [self.contentView addSubview:self.backIm];
        [self.backIm addSubview:self.cover];
        [self.backIm addSubview:self.conerV];
        [self.backIm addSubview:self.titleLabel];
        [self.backIm addSubview:self.typeLabel];
        [self.backIm addSubview:self.typeDetailLabel];
        [self.backIm addSubview:self.weakView];
        [self.backIm addSubview:self.coinNumberLabel];
        [self.backIm addSubview:self.coinIM];
        [self.backIm addSubview:self.buyPriceLabel];
        [self.backIm addSubview:self.shopBtn];
        [self.backIm addSubview:self.justUseBtn];
    }
    return self;
}
-(UIImageView *)backIm {
    if (!_backIm) {
        _backIm =[[UIImageView alloc] initWithFrame:CGRectMake(15,0,kScreenWidth-30,170)];
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
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.cover.frame)+15,CGRectGetMinY(self.cover.frame)+10,80,15)];
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
        _typeLabel.layer.borderColor =[keyColor CGColor];
        [AppUtils getConfigueLabel:_typeLabel font:PingFangSCRegular10 aliment:NSTextAlignmentCenter textcolor:keyColor text:@"折扣劵"];
    }
    return _typeLabel;
}
-(UILabel *)typeDetailLabel {
    if (!_typeDetailLabel) {
        _typeDetailLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.typeLabel.frame),CGRectGetMaxY(self.typeLabel.frame)+10,300,10)];
        [AppUtils getConfigueLabel:_typeDetailLabel font:PingFangSCRegular12 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"999999"] text:@""];
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

//乐币数量
-(UILabel *)coinNumberLabel {
    if (!_coinNumberLabel) {
        _coinNumberLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.backIm.frame)-15-25,CGRectGetMaxY(self.weakView.frame)+10,25,14)];
        [AppUtils getConfigueLabel:_coinNumberLabel font:BoldFont14 aliment:NSTextAlignmentLeft textcolor:keyColor text:@"400"];
    }
    return _coinNumberLabel;
}
-(UIImageView *)coinIM {
    if (!_coinIM) {
        _coinIM =[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.coinNumberLabel.frame)-5-15,CGRectGetMinY(self.coinNumberLabel.frame)-0.5,15,15)];
        _coinIM.image =[UIImage imageNamed:@"sp_lb"];
    }
    return _coinIM;
}
-(UILabel *)buyPriceLabel {
    if (!_buyPriceLabel) {
        _buyPriceLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.coinNumberLabel.frame)-5-300,CGRectGetMinY(self.coinNumberLabel.frame),300,CGRectGetHeight(self.coinNumberLabel.frame))];
        [AppUtils getConfigueLabel:_buyPriceLabel font:PingFangSCMedium13 aliment:NSTextAlignmentRight textcolor:[UIColor colorFromHexString:@"666666"] text:@""];
    }
    return _buyPriceLabel;
}

//
-(UIButton *)shopBtn {
    if (!_shopBtn) {
        _shopBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _shopBtn.frame = CGRectMake(CGRectGetWidth(self.backIm.frame)-15-65,CGRectGetMaxY(self.coinNumberLabel.frame)+12,65,25);
        [AppUtils getButton:_shopBtn font:PingFangSCRegular12 titleColor:keyColor title:@"邀请好友"];
        _shopBtn.layer.cornerRadius = 5;
        _shopBtn.layer.masksToBounds = YES;
        _shopBtn.layer.borderWidth  =1;
        _shopBtn.layer.borderColor =[keyColor CGColor];
        _shopBtn.backgroundColor =[UIColor whiteColor];
        _shopBtn.tag = 2;
        [_shopBtn addTarget:self action:@selector(SenderClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shopBtn;
}
-(UIButton *)justUseBtn {
    if (!_justUseBtn) {
        _justUseBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _justUseBtn.frame = CGRectMake(CGRectGetMinX(self.shopBtn.frame)-10-65,CGRectGetMinY(self.shopBtn.frame),CGRectGetWidth(self.shopBtn.frame),CGRectGetHeight(self.shopBtn.frame));
        [AppUtils getButton:_justUseBtn font:PingFangSCRegular12 titleColor:[UIColor colorFromHexString:@"333333"] title:@"取消订单"];
        _justUseBtn.layer.cornerRadius = 5;
        _justUseBtn.layer.masksToBounds = YES;
        _justUseBtn.layer.borderWidth =1;
        _justUseBtn.layer.borderColor =[RGB(204,204,204) CGColor];
        _justUseBtn.backgroundColor =[UIColor whiteColor];
        _justUseBtn.tag = 3;
        [_justUseBtn addTarget:self action:@selector(SenderClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _justUseBtn;
}

-(void)setList:(Hk_subOrderList *)list {
    _list = list;
    [AppUtils seImageView:self.cover withUrlSting:list.imgSrc placeholderImage:nil];
    self.typeDetailLabel.text =[NSString stringWithFormat:@"商品原价: ￥%zd",list.price];
    if (list.discount) {
        self.conerV.hidden =NO;
         self.conerV.image =[UIImage imageNamed:[NSString stringWithFormat:@"xrzx_%zdz",list.discount]];
    }else {
        self.conerV.hidden =YES;
    }
    
 //赋值 修改LabelFrame
    NSString *counStr =[NSString stringWithFormat:@"%.2f",list.integral];
    CGRect rect =[counStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX,14) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSForegroundColorAttributeName:keyColor,NSFontAttributeName:BoldFont14} context:nil];
    self.coinNumberLabel.text = counStr;
    self.coinNumberLabel.frame = CGRectMake(CGRectGetWidth(self.backIm.frame)-15-rect.size.width,self.coinNumberLabel.frame.origin.y,rect.size.width,14);
    self.coinIM.frame =CGRectMake(CGRectGetMinX(self.coinNumberLabel.frame)-5-15,CGRectGetMinY(self.coinNumberLabel.frame)-0.5,15,15);
    self.buyPriceLabel.frame =CGRectMake(CGRectGetMinX(self.coinIM.frame)-5-300,CGRectGetMinY(self.coinNumberLabel.frame),300,CGRectGetHeight(self.coinNumberLabel.frame));
    self.buyPriceLabel.text =[NSString stringWithFormat:@"共1件商品 实付款 :"];
}
#pragma mark 点击事件
-(void)SenderClick:(UIButton *)sender {
    if (self.block) {
        self.block(self.list, sender.tag);
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
