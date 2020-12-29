//
//  HKFrindCicleInfoCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKFrindCicleInfoCell.h"

@interface HKFrindCicleInfoCell ()


@end

@implementation HKFrindCicleInfoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.cicleNameLabel];
        [self.contentView addSubview:self.tagLabel];
        [self.contentView addSubview:self.row];
    }
    return self;
}
-(UIImageView*)iconImageView {
    if (!_iconImageView) {
        _iconImageView =[[UIImageView alloc] initWithFrame:CGRectMake(15,3,48,48)];
        _iconImageView.layer.cornerRadius =24;
        _iconImageView.layer.masksToBounds =YES;
        _iconImageView.image =[UIImage imageNamed:@"back4.jpg"];
    }
    return _iconImageView;
}

-(UIImageView *)row {
    if (!_row) {
        _row =[[UIImageView alloc]init];
        _row.frame = CGRectMake(kScreenWidth-15-10,CGRectGetMinY(self.iconImageView.frame)+19,6,10);
        _row.image =[UIImage imageNamed:@"right"];
        _row.hidden =YES;
    }
    return _row;
}
-(UILabel *)cicleNameLabel {
    if (!_cicleNameLabel) {
        _cicleNameLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+8,CGRectGetMinY(self.iconImageView.frame)+7,kScreenWidth,20)];
        [AppUtils getConfigueLabel:_cicleNameLabel font:PingFangSCRegular16 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@"创意生活DIY"];
    }
    return _cicleNameLabel;
}
-(UILabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.cicleNameLabel.frame),CGRectGetMaxY(self.cicleNameLabel.frame)+8,CGRectGetWidth(self.cicleNameLabel.frame),10)];
         [AppUtils getConfigueLabel:_tagLabel font:PingFangSCRegular13 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"999999"] text:@"易生活 583人"];
    }
    return _tagLabel;
}
-(void)setResponse:(HKMediaCicleData *)response {
    _response  =response;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:response.coverImgSrc] placeholderImage:[UIImage imageNamed:@"back3.jpg"]];
    self.cicleNameLabel.text =response.categoryName;
    self.tagLabel.text =[NSString stringWithFormat:@"%@ %zd人",response.circleName,response.circleCount];
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
