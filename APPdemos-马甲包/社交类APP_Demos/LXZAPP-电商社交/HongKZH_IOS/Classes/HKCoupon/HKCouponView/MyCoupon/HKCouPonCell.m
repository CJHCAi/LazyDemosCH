//
//  HKCouPonCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/26.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCouPonCell.h"

@interface HKCouPonCell ()
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
//购入价
@property (nonatomic, strong)UILabel * buyPriceLabel;
//乐币数量
@property (nonatomic, strong)UILabel * coinNumberLabel;
//去出售
@property (nonatomic, strong)UIButton *justUseBtn;
//立即使用
@property (nonatomic, strong)UIButton *shopBtn;
//优惠券状态
@property (nonatomic, strong)UIImageView * stateView;
@end

@implementation HKCouPonCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = UICOLOR_RGB_Alpha(0xf2f2f2, 1);
        [self.contentView addSubview:self.backIm];
        [self.backIm addSubview:self.cover];
        [self.backIm addSubview:self.conerV];
        [self.backIm addSubview:self.titleLabel];
        [self.backIm addSubview:self.typeLabel];
        [self.backIm addSubview:self.typeDetailLabel];
        [self.backIm addSubview:self.weakView];
        [self.backIm addSubview:self.buyPriceLabel];
        [self.backIm addSubview:self.coinNumberLabel];
        [self.backIm addSubview:self.shopBtn];
        [self.backIm addSubview:self.justUseBtn];
        [self.backIm addSubview:self.stateView];
    }
    return self;
}
-(UIImageView *)backIm {
    if (!_backIm) {
        _backIm =[[UIImageView alloc] initWithFrame:CGRectMake(15,10,kScreenWidth-30,150)];
        _backIm.image =[UIImage imageNamed:@"sy_js_bg"];
        _backIm.userInteractionEnabled =YES;
    }
    return _backIm;
}
-(UIImageView *)stateView {
    if (!_stateView) {
        UIImage *stateM =[UIImage imageNamed:@"yhq_onDate"];
        _stateView =[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.backIm.frame)-10-stateM.size.width,10,stateM.size.width,stateM.size.height)];
    }
    return _stateView;
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
        _buyPriceLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.cover.frame),CGRectGetMaxY(self.weakView.frame)+15,45,20)];
        [AppUtils getConfigueLabel:_buyPriceLabel font:PingFangSCRegular13 aliment:NSTextAlignmentLeft textcolor:RGB(102,102,102) text:@"购入价:"];
    }
    return _buyPriceLabel;
}
-(UILabel *)coinNumberLabel {
    if (!_coinNumberLabel) {
        _coinNumberLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.buyPriceLabel.frame)+5,CGRectGetMinY(self.buyPriceLabel.frame),200,CGRectGetHeight(self.buyPriceLabel.frame))];
        [AppUtils getConfigueLabel:_coinNumberLabel font:PingFangSCRegular13 aliment:NSTextAlignmentLeft textcolor:RGB(230,89,60) text:@""];
        [self configuLabelImageWith:260];
        _coinNumberLabel.attributedText = [self configuLabelImageWith:250];
    }
    return _coinNumberLabel;
}
-(NSMutableAttributedString *)configuLabelImageWith:(double)count {
    NSString *countStr =[NSString stringWithFormat:@"%.2lf ",count];
    //NSTextAttachment可以将要插入的图片作为特殊字符处理
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    //定义图片内容及位置和大小
    attch.image = [UIImage imageNamed:@"yhq_lb"];
    attch.bounds = CGRectMake(0,-4,20,20);
    //创建带有图片的富文本
    NSAttributedString * string = [NSAttributedString attributedStringWithAttachment:attch];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",countStr]];
    [attri insertAttributedString:string atIndex:0];
    return  attri;
}
-(UIButton *)shopBtn {
    if (!_shopBtn) {
        _shopBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _shopBtn.frame = CGRectMake(CGRectGetWidth(self.backIm.frame)-15-65,CGRectGetMaxY(self.weakView.frame)+12,65,25);
        [AppUtils getButton:_shopBtn font:PingFangSCRegular12 titleColor:RGB(230,89,60) title:@"去出售"];
        _shopBtn.layer.cornerRadius = 5;
        _shopBtn.layer.masksToBounds = YES;
        _shopBtn.layer.borderWidth  =1;
        _shopBtn.layer.borderColor =[RGB(230,89, 60) CGColor];
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
        [AppUtils getButton:_justUseBtn font:PingFangSCRegular12 titleColor:RGB(230,89,60) title:@"立即使用"];
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
#pragma mark 点击事件
-(void)SenderClick:(UIButton *)sender {
    
    if (self.delegete && [self.delegete respondsToSelector:@selector(setClickDelegeteWithModel:andSender:WithNSIndexPath:)]) {
        [self.delegete setClickDelegeteWithModel:self.model andSender:sender.tag WithNSIndexPath:self.indexPath];
    }
}
-(void)setModel:(HKCounList *)model {
    _model  = model;
    [AppUtils seImageView:self.cover withUrlSting:model.imgSrc placeholderImage:nil];
    if (model.state==1) {
        //正常
        self.stateView.image =[UIImage imageNamed:@"yhq_onDate"];
        self.justUseBtn.hidden = NO;
        [self.shopBtn setTitle:@"去出售" forState:UIControlStateNormal];
        [self.shopBtn setTitleColor:keyColor forState:UIControlStateNormal];
        self.shopBtn.layer.borderWidth =1;
        self.shopBtn.layer.borderColor =[keyColor CGColor];
    }else if (model.state==4) {
      //使用
         self.stateView.image =[UIImage imageNamed:@"yhq_Hasuse"];
        self.justUseBtn.hidden  = YES;
        [self.shopBtn setTitle:@"删除" forState:UIControlStateNormal];
        [self.shopBtn setTitleColor:RGB(51,51,51) forState:UIControlStateNormal];
         self.shopBtn.layer.borderWidth =1;
        self.shopBtn.layer.borderColor =[RGB(204,204,204) CGColor];
        
    }else if (model.state ==3){
       //过期
         self.stateView.image =[UIImage imageNamed:@"yhq_outData"];
         self.justUseBtn.hidden  = YES;
         [self.shopBtn setTitle:@"删除" forState:UIControlStateNormal];
         [self.shopBtn setTitleColor:RGB(51,51,51) forState:UIControlStateNormal];
         self.shopBtn.layer.borderWidth =1;
         self.shopBtn.layer.borderColor =[RGB(204,204,204) CGColor];
    }
    self.typeLabel.text =@"折扣劵";
    self.coinNumberLabel.hidden =NO;
    self.titleLabel.text =model.title;
    self.buyPriceLabel.frame = CGRectMake(CGRectGetMinX(self.cover.frame),CGRectGetMaxY(self.weakView.frame)+15,45,20);
    self.buyPriceLabel.text=@"购入价:";
    self.typeDetailLabel.text =[NSString stringWithFormat:@"商品原价: ￥%zd",model.pintegral];
    if (model.discount) {
        self.conerV.hidden = NO;
        self.conerV.image =[UIImage imageNamed:[NSString stringWithFormat:@"xrzx_%zdz",model.discount]];
    }else {
        self.conerV.hidden = YES;
    }
    self.coinNumberLabel.attributedText =[self configuLabelImageWith:model.integral];
}


#pragma mark 新人专享..
-(void)setVipData:(HKVipData *)vipData {
    _vipData = vipData;
    self.cover.image =[UIImage imageNamed:@"yhq_xrzxq"];
    if (vipData.state.intValue==1) {
        //正常
        self.stateView.image =[UIImage imageNamed:@"yhq_onDate"];
        self.justUseBtn.hidden = NO;
        [self.shopBtn setTitle:@"去出售" forState:UIControlStateNormal];
        [self.shopBtn setTitleColor:keyColor forState:UIControlStateNormal];
        self.shopBtn.layer.borderWidth =1;
        self.shopBtn.layer.borderColor =[keyColor CGColor];
        
    }else if (vipData.state.intValue==4) {
        //使用
        self.stateView.image =[UIImage imageNamed:@"yhq_Hasuse"];
        self.justUseBtn.hidden  = YES;
        [self.shopBtn setTitle:@"删除" forState:UIControlStateNormal];
        [self.shopBtn setTitleColor:RGB(51,51,51) forState:UIControlStateNormal];
        self.shopBtn.layer.borderWidth =1;
        self.shopBtn.layer.borderColor =[RGB(204,204,204) CGColor];
        
    }else if (vipData.state.intValue ==3){
        //过期
        self.stateView.image =[UIImage imageNamed:@"yhq_outData"];
        self.justUseBtn.hidden  = YES;
        [self.shopBtn setTitle:@"删除" forState:UIControlStateNormal];
        [self.shopBtn setTitleColor:RGB(51,51,51) forState:UIControlStateNormal];
        self.shopBtn.layer.borderWidth =1;
        self.shopBtn.layer.borderColor =[RGB(204,204,204) CGColor];
    }
    self.typeLabel.text =@"资格劵";
    self.titleLabel.text =vipData.title;
     self.buyPriceLabel.frame = CGRectMake(CGRectGetMinX(self.cover.frame),CGRectGetMaxY(self.weakView.frame)+15,200,20);
    self.buyPriceLabel.text =@"仅可在新人专享里使用";
    self.typeDetailLabel.text =[NSString stringWithFormat:@"有效期: %@-%@",vipData.beginDate,vipData.endDate];
    self.conerV.hidden =YES;
    self.coinNumberLabel.hidden = YES;
}
#pragma mark 折扣劵赋值
-(void)setList:(HKDisCutList *)list {
    _list = list;
     [AppUtils seImageView:self.cover withUrlSting:list.imgSrc placeholderImage:nil];
    if (list.discount) {
        self.conerV.hidden = NO;
        self.conerV.image =[UIImage imageNamed:[NSString stringWithFormat:@"xrzx_%.fz",list.discount]];
    }else {
        self.conerV.hidden = YES;
    }
    self.coinNumberLabel.attributedText =[self configuLabelImageWith:list.integral];
    self.titleLabel.text =list.title;
   // self.typeDetailLabel.text =[NSString stringWithFormat:@"商品原价: ￥%zd",list.pintegral];

}
-(void)setSuccessCell {
    self.buyPriceLabel.text =@" 售价:";
    self.justUseBtn.hidden = YES;
    [self.shopBtn setTitle:@"立即购买" forState:UIControlStateNormal];

}

- (void)awakeFromNib {
    [super awakeFromNib];
   
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
