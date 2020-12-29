//
//  HKFriendBaseInfoCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKFriendBaseInfoCell.h"

@interface HKFriendBaseInfoCell ()
@property (nonatomic, strong)UILabel * titleLabel;
//乐看号
@property (nonatomic, strong)UILabel *idLabel;
//家乡
@property (nonatomic, strong)UILabel *cityLabel;
//星座
@property (nonatomic, strong)UILabel *constellationLabel;
//职业
@property (nonatomic, strong)UILabel *josLabel;
//注册日期
@property (nonatomic, strong)UILabel *registerDateLabel;
//关系
@property (nonatomic, strong)UILabel *relationLabel;

@end

@implementation HKFriendBaseInfoCell
//210
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.idLabel];
        [self.contentView addSubview:self.cityLabel];
        [self.contentView addSubview:self.constellationLabel];
        [self.contentView addSubview:self.josLabel];
        [self.contentView addSubview:self.registerDateLabel];
        [self.contentView addSubview:self.relationLabel];
    }
    return self;
}

-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(15,20,200,14)
                      ];
        [AppUtils getConfigueLabel:_titleLabel font:PingFangSCRegular14 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"000000"] text:@"信息"];
    }
    return _titleLabel;
}
-(UILabel *)idLabel {
    if (!_idLabel) {
        _idLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame),CGRectGetMaxY(self.titleLabel.frame)+12,300,15)];
        [AppUtils getConfigueLabel:_idLabel font:PingFangSCRegular14 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"666666"] text:@""];
    }
    return _idLabel;
}
-(UILabel *)cityLabel {
    if (!_cityLabel) {
        _cityLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame),CGRectGetMaxY(self.idLabel.frame)+10,200,CGRectGetHeight(self.idLabel.frame))];
        [AppUtils getConfigueLabel:_cityLabel font:PingFangSCRegular14 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"666666"] text:@""];
    }
    return _cityLabel;
}
-(UILabel *)constellationLabel {
    if (!_constellationLabel) {
        _constellationLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame),CGRectGetMaxY(self.cityLabel.frame)+10,200,CGRectGetHeight(self.idLabel.frame))];
        [AppUtils getConfigueLabel:_constellationLabel font:PingFangSCRegular14 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"666666"] text:@""];
    }
    return _constellationLabel;
}
-(UILabel *)josLabel {
    if (!_josLabel) {
        _josLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame),CGRectGetMaxY(self.constellationLabel.frame)+10,200,CGRectGetHeight(self.idLabel.frame))];
        [AppUtils getConfigueLabel:_josLabel font:PingFangSCRegular14 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"666666"] text:@""];
    }
    return _josLabel;
}

-(UILabel *)registerDateLabel {
    if (!_registerDateLabel) {
        _registerDateLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame),CGRectGetMaxY(self.josLabel.frame)+10,200,CGRectGetHeight(self.idLabel.frame))];
        [AppUtils getConfigueLabel:_registerDateLabel font:PingFangSCRegular14 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"666666"] text:@""];
    }
    return _registerDateLabel;
}
-(UILabel *)relationLabel {
    if (!_relationLabel) {
        _relationLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame),CGRectGetMaxY(self.registerDateLabel.frame)+10,200,CGRectGetHeight(self.idLabel.frame))];
        [AppUtils getConfigueLabel:_relationLabel font:PingFangSCRegular14 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"666666"] text:@""];
    }
    return _relationLabel;
}
-(void)setResponse:(HKMediaInfoResponse *)response {
    _response = response;
    self.idLabel.text =[NSString stringWithFormat:@"乐看号: %@",response.data.uid];
    if (response.data.loginAddress.length) {
        self.cityLabel.text =[NSString stringWithFormat:@"家乡: %@",response.data.loginAddress];
    }else {
        self.cityLabel.text =@"家乡: 未设置";
    }
    if (response.data.constellation.length) {
        self.constellationLabel.text =[NSString stringWithFormat:@"星座: %@",response.data.constellation];
    }else {
        self.constellationLabel.text =@"星座: 未设置";
    }
    if (response.data.occupation.length) {
        self.josLabel.text =[NSString stringWithFormat:@"职业: %@",response.data.occupation];
    }else {
        self.josLabel.text =[NSString stringWithFormat:@"职业: 未设置"];
    }
    if (response.data.createDate.length) {
        self.registerDateLabel.text=[NSString stringWithFormat:@"注册日期: %@",response.data.createDate];
    }else {
        self.registerDateLabel.text =[NSString stringWithFormat:@"注册日期: 未设置"];
    }
    if (response.data.friendId.length) {
        self.relationLabel.text =@"关系: 好友";
    }else {
        self.relationLabel.text =@"关系: 陌生人";
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
