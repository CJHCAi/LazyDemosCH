//
//  HKCollageCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/3.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCollageCell.h"

@interface HKCollageCell ()
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
//乐币数量
@property (nonatomic, strong)UILabel * coinNumberLabel;
//去拼单
@property (nonatomic, strong)UILabel *collageBtn;
//拼件数 2人团
@property (nonatomic, strong)UILabel * pinCoutLabel;

@end

@implementation HKCollageCell

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
        [self.backIm addSubview:self.collageBtn];
        [self.backIm addSubview:self.coinNumberLabel];
        [self.backIm addSubview:self.pinCoutLabel];

    }
    return  self;
}
-(UIImageView *)backIm {
    if (!_backIm) {
        _backIm =[[UIImageView alloc] initWithFrame:CGRectMake(15,10,kScreenWidth-30,140)];
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
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.cover.frame)+15,17,CGRectGetWidth(self.backIm.frame)-CGRectGetMaxX(self.cover.frame)-15-18,18)];
        [AppUtils getConfigueLabel:_titleLabel font:PingFangSCMedium15 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@"高姿尽头亮肤失约色影"];
    }
    return _titleLabel;
}
-(UILabel *)typeLabel
{
    if (!_typeLabel) {
        _typeLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame),CGRectGetMaxY(self.titleLabel.frame)+7,38,16)];
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
        [AppUtils getConfigueLabel:_typeDetailLabel font:PingFangSCRegular12 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"999999"] text:@"商品原价: ￥172"];
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
-(UILabel *)coinNumberLabel {
    if (!_coinNumberLabel) {
        _coinNumberLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.cover.frame),CGRectGetMaxY(self.weakView.frame)+8,200,20)];
        [AppUtils getConfigueLabel:_coinNumberLabel font:PingFangSCRegular13 aliment:NSTextAlignmentLeft textcolor:RGB(230,89,60) text:@""];
        [self configuLabelImageWith:260];
        _coinNumberLabel.attributedText = [self configuLabelImageWith:250];
    }
    return _coinNumberLabel;
}
-(NSMutableAttributedString *)configuLabelImageWith:(NSInteger)count {
    NSString *countStr =[NSString stringWithFormat:@"% zd",count];
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
-(UILabel *)collageBtn {
    if (!_collageBtn) {
        _collageBtn =[[UILabel alloc] init];
        _collageBtn.frame = CGRectMake(CGRectGetWidth(self.backIm.frame)-15-65,CGRectGetMaxY(self.weakView.frame)+8,65,25);
        [AppUtils getConfigueLabel:_collageBtn font:PingFangSCMedium12 aliment:NSTextAlignmentCenter textcolor:keyColor text:@"去拼单"];
        _collageBtn.layer.cornerRadius = 5;
        _collageBtn.layer.masksToBounds = YES;
        _collageBtn.borderColor = keyColor;
        _collageBtn.borderWidth = 1;
    }
    return _collageBtn;
}
-(UILabel *)pinCoutLabel {
    if (!_pinCoutLabel) {
        _pinCoutLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.collageBtn.frame)-300-10,CGRectGetMaxY(self.weakView.frame)+14,300,12)];
        [AppUtils getConfigueLabel:_pinCoutLabel font:PingFangSCRegular13 aliment:NSTextAlignmentRight textcolor:RGB(102,102,102) text:@"sssss"];
    }
    return _pinCoutLabel;
}

#pragma mark 去拼单......
-(void)collageAction:(UIButton *)sender {
    if (self.block) {
        self.block(self.list.collageCouponId);
    }
}
-(void)setList:(HKCollageBaseList *)list {
    [AppUtils seImageView:self.cover withUrlSting:list.imgSrc placeholderImage:nil];
    self.titleLabel.text = list.title;
    self.typeDetailLabel.text =[NSString stringWithFormat:@"商品原价: ￥%zd",list.pintegral];
    self.coinNumberLabel.attributedText =[self configuLabelImageWith:list.integral];
    NSString *firstStr =[NSString stringWithFormat:@"已拼%zd件",list.orders];
    NSString *secStr =[NSString stringWithFormat:@"%zd人团",list.num];
    NSString * totalStr =[NSString stringWithFormat:@"%@ %@",firstStr,secStr];
    NSMutableAttributedString * attbution =[[NSMutableAttributedString alloc] initWithString:totalStr];
    [attbution addAttribute:NSForegroundColorAttributeName value:keyColor range:NSMakeRange(firstStr.length,secStr.length)];
    self.pinCoutLabel.attributedText = attbution;
    if (list.discount) {
        self.conerV.hidden = NO;
        self.conerV.image =[UIImage imageNamed:[NSString stringWithFormat:@"xrzx_%zdz",list.discount]];
    }else {
        self.conerV.hidden = YES;
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
