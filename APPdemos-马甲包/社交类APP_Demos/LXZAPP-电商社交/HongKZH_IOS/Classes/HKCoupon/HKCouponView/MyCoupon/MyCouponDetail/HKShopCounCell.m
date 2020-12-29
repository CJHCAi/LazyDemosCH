//
//  HKShopCounCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/1.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKShopCounCell.h"

@interface HKShopCounCell ()
@property (nonatomic, strong)UILabel * titleLabel;
@property (nonatomic, strong)UIImageView * goodV;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel * priceLabel;
@end
@implementation HKShopCounCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor =[UIColor whiteColor];
        [self addSubview:self.titleLabel];
        [self addSubview:self.goodV];
        [self addSubview:self.nameLabel];
        [self addSubview:self.priceLabel];
    }
    return  self;
}

-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(15,15,120,15)];
        [AppUtils getConfigueLabel:_titleLabel font:PingFangSCRegular15 aliment:NSTextAlignmentLeft textcolor:RGB(51,51,51) text:@"适用商品"];
    }
    return _titleLabel;
}

-(UIImageView *)goodV {
    if (!_goodV) {
        _goodV =[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame),CGRectGetMaxY(self.titleLabel.frame)+15,80,80)];
        _goodV.image =[UIImage imageNamed:@"splb_img_01"];
    }
    return _goodV;
}
-(UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.goodV.frame)+13,CGRectGetMinY(self.goodV.frame),kScreenWidth-CGRectGetMaxX(self.goodV.frame)-13-32,40)];
        [AppUtils getConfigueLabel:_nameLabel font:PingFangSCRegular14 aliment:NSTextAlignmentLeft textcolor:RGB(51,51,51) text:@"暂无商品详情介绍"];
        _nameLabel.numberOfLines = 0;
    }
    return _nameLabel;
}

//150...
-(UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.nameLabel.frame),CGRectGetMaxY(self.nameLabel.frame)+15,CGRectGetWidth(self.nameLabel.frame),15)];
        [AppUtils getConfigueLabel:_priceLabel font:PingFangSCRegular15 aliment:NSTextAlignmentLeft textcolor:keyColor text:@""];
    }
    return _priceLabel;
}
-(void)setResponse:(HKMyCopunDetailResponse *)response {
    _response = response;
    [self.goodV sd_setImageWithURL:[NSURL URLWithString:response.data.imgSrc]
     ];
    if (response.data.remarks.length) {
        //说明
        self.titleLabel.text = response.data.remarks;
    }
    NSString * priStr = [NSString stringWithFormat:@"￥%zd.00",response.data.pintegral];
    NSMutableAttributedString * attbute =[[NSMutableAttributedString alloc] initWithString:priStr];
    [attbute addAttribute:NSFontAttributeName value:PingFangSCRegular12 range:NSMakeRange(0,1)];
    self.priceLabel.attributedText = attbute;
}

-(void)setCollageRes:(HKCollageResPonse *)collageRes {
    _collageRes = collageRes;
    [self.goodV sd_setImageWithURL:[NSURL URLWithString:collageRes.data.imgSrc]
     ];
    if (collageRes.data.title.length) {
        //说明
        self.titleLabel.text = collageRes.data.title;
    }
    NSString * priStr = [NSString stringWithFormat:@"￥%zd.00",collageRes.data.pintegral];
    NSMutableAttributedString * attbute =[[NSMutableAttributedString alloc] initWithString:priStr];
    [attbute addAttribute:NSFontAttributeName value:PingFangSCRegular12 range:NSMakeRange(0,1)];
    self.priceLabel.attributedText = attbute;
}

-(void)setVipResponse:(HKUserVipResponse *)vipResponse {
    _vipResponse = vipResponse;
    [self.goodV sd_setImageWithURL:[NSURL URLWithString:vipResponse.data.imgSrc]
     ];
    if (vipResponse.data.title.length) {
        //说明
       // self.titleLabel.text = vipResponse.data.title;
    }
    NSString * priStr = [NSString stringWithFormat:@"￥%zd.00",vipResponse.data.pintegral];
    NSMutableAttributedString * attbute =[[NSMutableAttributedString alloc] initWithString:priStr];
    [attbute addAttribute:NSFontAttributeName value:PingFangSCRegular12 range:NSMakeRange(0,1)];
    self.priceLabel.attributedText = attbute;
    
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
