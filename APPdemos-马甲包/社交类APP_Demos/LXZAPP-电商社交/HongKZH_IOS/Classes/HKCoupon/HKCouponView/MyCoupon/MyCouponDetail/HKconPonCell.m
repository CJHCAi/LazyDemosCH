//
//  HKconPonCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/1.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKconPonCell.h"

@interface HKconPonCell ()
@property (nonatomic, strong)UIImageView *backIm;
@property (nonatomic, strong)UILabel * disCountLabel;
@property (nonatomic, strong)UILabel * carecterlabel;
@property (nonatomic, strong)UIImageView * lineRedV;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIImageView * iconV;
@property (nonatomic, strong)UILabel *countLabel;
@property (nonatomic, strong)UILabel *timeLabel;

@end

@implementation HKconPonCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor =[UIColor whiteColor];
        [self.contentView addSubview:self.backIm];
        [self.backIm addSubview:self.disCountLabel];
        [self.backIm addSubview:self.carecterlabel];
       // [self.contentView addSubview:self.lineRedV];
        [self.backIm addSubview:self.titleLabel];
        [self.backIm addSubview:self.iconV];
        [self.backIm addSubview:self.countLabel];
        [self.backIm addSubview:self.timeLabel];
        
    }
    return self;
}

-(UIImageView *)backIm {
    if (!_backIm) {
        _backIm =[[UIImageView alloc] initWithFrame:CGRectMake(15,15,kScreenWidth-30,125)];
        _backIm.image =[UIImage imageNamed:@"collageBack"];
    }
    return _backIm;
}
-(UILabel *)disCountLabel {
    if (!_disCountLabel) {
        _disCountLabel=[[UILabel alloc] initWithFrame:CGRectMake(28,34,30,50)];
        [AppUtils getConfigueLabel:_disCountLabel font:[UIFont boldSystemFontOfSize:50] aliment:NSTextAlignmentCenter textcolor:keyColor text:@"6"];
    }
    return _disCountLabel;
}

-(UILabel *)carecterlabel {
    if (!_carecterlabel) {
        _carecterlabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.disCountLabel.frame),CGRectGetMinY(self.disCountLabel.frame)+27,16,16)];
        [AppUtils getConfigueLabel:_carecterlabel font:PingFangSCRegular16 aliment:NSTextAlignmentLeft textcolor:keyColor text:@"折"];
    }
    return _carecterlabel;
}


-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.carecterlabel.frame)+30,15,CGRectGetWidth(self.backIm.frame)-CGRectGetMaxX(self.carecterlabel.frame)-40,50)];
        [AppUtils getConfigueLabel:_titleLabel font:PingFangSCRegular16 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@"高姿净透亮丽肌肤卸妆水失约月色荧光透亮"];
        _titleLabel.numberOfLines =0;
    }
    return _titleLabel;
}
-(UIImageView *)iconV {
    if (!_iconV) {
        _iconV =[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame),CGRectGetMaxY(self.titleLabel.frame)+8,15,15)];
        _iconV.image =[UIImage imageNamed:@"sp_lb"];
    }
    return _iconV;
}
-(UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconV.frame)+5,CGRectGetMaxY(self.titleLabel.frame)+5,150,20)];
        _countLabel.numberOfLines =1;
        [AppUtils getConfigueLabel:_countLabel font:PingFangSCRegular20 aliment:NSTextAlignmentLeft textcolor:keyColor text:@"360"];
    }
    return _countLabel;
}
-(UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame),CGRectGetMaxY(self.iconV.frame)+8,CGRectGetWidth(self.titleLabel.frame),16)];
        [AppUtils getConfigueLabel:_timeLabel font:PingFangSCRegular12 aliment:NSTextAlignmentLeft textcolor:RGB(102,102,102) text:@"有效期: 2018.09.1-2018.9.30"];
    }
    return _timeLabel;
}

-(void)setResponse:(HKMyCopunDetailResponse *)response {
    _response = response;
    self.disCountLabel.text =[NSString stringWithFormat:@"%zd",response.data.discount];
    if (response.data.title.length) {
        self.titleLabel.text = response.data.title;
    }
    self.countLabel.text =[NSString stringWithFormat:@"%.2lf",response.data.integral];
    self.timeLabel.text =[NSString stringWithFormat:@"有效期: %@至%@",response.data.beginTime,response.data.endTime];
}

-(void)setCollageRes:(HKCollageResPonse *)collageRes {
    _collageRes = collageRes;
    self.disCountLabel.text =[NSString stringWithFormat:@"%zd",collageRes.data.discount];
    if (collageRes.data.remarks.length) {
        self.titleLabel.text = collageRes.data.ctitle;
    }
     self.countLabel.text =[NSString stringWithFormat:@"%.2lf",collageRes.data.integral];
    self.timeLabel.text =[NSString stringWithFormat:@"有效期: %@至%@",collageRes.data.beginTime,collageRes.data.endTime];
}

-(void)setVipResponse:(HKUserVipResponse *)vipResponse {
    _vipResponse = vipResponse;
    self.disCountLabel.text =[NSString stringWithFormat:@"%zd",vipResponse.data.discount];
    if (vipResponse.data.title.length) {
        self.titleLabel.text = vipResponse.data.title;
    }
    self.countLabel.text =[NSString stringWithFormat:@"%.2lf",vipResponse.data.integral];
    self.timeLabel.text =[NSString stringWithFormat:@"有效期: %@至%@",vipResponse.data.beginTime,vipResponse.data.endTime];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
