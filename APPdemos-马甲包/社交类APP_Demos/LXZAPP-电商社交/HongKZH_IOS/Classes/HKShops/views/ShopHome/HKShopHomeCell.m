//
//  HKShopHomeCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKShopHomeCell.h"

@interface HKShopHomeCell ()

@property (nonatomic, strong)UIImageView *cover;
@property (nonatomic, strong)UILabel * titleLabel;
@property (nonatomic, strong)UILabel *copunLabel;
@property (nonatomic, strong)UILabel *priceLabel;
@end

@implementation HKShopHomeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor =[UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.cover];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.copunLabel];
        [self.contentView addSubview:self.priceLabel];
    }
    return self;
}
-(UIImageView *)cover {
    if (!_cover) {
        _cover =[[UIImageView alloc] initWithFrame:CGRectMake(15,15,120,120)];
        _cover.image =[UIImage imageNamed:@"xtxx_img_02"];
        
    }
    return _cover;
}
-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.cover.frame)+10,CGRectGetMinY(self.cover.frame)+5,kScreenWidth-30-120-10,44)];
        [AppUtils getConfigueLabel:_titleLabel font:PingFangSCRegular15 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@"香港2018秋季黑色乐福鞋看脚跟厚重百搭拼读投机让退"];
        _titleLabel.numberOfLines =0;
        
    }
    return _titleLabel;
}
-(UILabel *)copunLabel
{
    if (!_copunLabel) {
        _copunLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame),CGRectGetMaxY(self.titleLabel.frame)+15,65,15)];
        [AppUtils getConfigueLabel:_copunLabel font:PingFangSCRegular10 aliment:NSTextAlignmentCenter textcolor:[UIColor whiteColor] text:@"可用折扣劵"];
        _copunLabel.backgroundColor =RGB(252,136,114);
        _copunLabel.layer.cornerRadius =6;
        _copunLabel.layer.masksToBounds =YES;
        
    }
    return _copunLabel;
}
-(UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.copunLabel.frame),CGRectGetMaxY(self.copunLabel.frame)+15,CGRectGetWidth(self.titleLabel.frame),20)];
        [AppUtils getConfigueLabel:_priceLabel font:PingFangSCRegular12 aliment:NSTextAlignmentLeft textcolor:RGBA(102,102,102, 1) text:@""];
    }
    return _priceLabel;
}

-(void)setListData:(HKRecomendList *)listData {
    _listData =listData;
    [AppUtils seImageView:self.cover withUrlSting:listData.imgSrc placeholderImage:nil];
    self.titleLabel.text =listData.title;
    NSString * counstr =[NSString stringWithFormat:@"%.2lf",listData.integral];
    NSString * price =[NSString stringWithFormat:@"售价: ￥%@",counstr];
    NSMutableAttributedString * pres =[[NSMutableAttributedString alloc] initWithString:price];
    [pres addAttribute:NSFontAttributeName value:PingFangSCRegular16 range:NSMakeRange(5,counstr.length)];
    [pres addAttribute:NSForegroundColorAttributeName value:RGB(239,89,60) range:NSMakeRange(4,1+counstr.length)];
    _priceLabel.attributedText = pres;
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
