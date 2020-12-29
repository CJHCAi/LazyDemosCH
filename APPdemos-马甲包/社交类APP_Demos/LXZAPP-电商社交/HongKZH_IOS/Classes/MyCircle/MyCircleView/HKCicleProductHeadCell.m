//
//  HKCicleProductHeadCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/30.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCicleProductHeadCell.h"

@interface HKCicleProductHeadCell ()
@property (nonatomic, strong)UIImageView *icon;
@property (nonatomic, strong)UILabel *counLabel;
@property (nonatomic, strong)UILabel *introLabel;
@property (nonatomic, strong)UIImageView *addressView;
@property (nonatomic, strong)UILabel * addressLabel;
@property (nonatomic, strong)UILabel *feeLabel;
@property (nonatomic, strong)UIView *lineV;
@property (nonatomic, strong)UILabel * selectLabel;
@property (nonatomic, strong)UIButton *rightBtn;

@end

@implementation HKCicleProductHeadCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor =[UIColor whiteColor];
        [self.contentView addSubview:self.icon];
        [self.contentView addSubview:self.counLabel];
        [self.contentView addSubview:self.introLabel];
        [self.contentView addSubview:self.addressView];
        [self.contentView addSubview:self.addressLabel];
        [self.contentView addSubview:self.feeLabel];
        [self.contentView addSubview:self.lineV];
        [self.contentView addSubview:self.selectLabel];
        [self.contentView addSubview:self.rightBtn];
    }
    return  self;
}
-(UIImageView *)icon {
    if (!_icon) {
        _icon =[[UIImageView alloc] initWithFrame:CGRectMake(15,15,15,15)];
        _icon.image =[UIImage imageNamed:@"yhq_lb"];
    }
    return _icon;
}
-(UILabel *)counLabel {
    if (!_counLabel) {
        _counLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.icon.frame)+6,CGRectGetMinY(self.icon.frame)-5,300,CGRectGetHeight(self.icon.frame)+10)];
        [AppUtils getConfigueLabel:_counLabel font:BoldFont22 aliment:NSTextAlignmentLeft textcolor:keyColor text:@"33"];
    }
    return _counLabel;
}
-(UILabel *)introLabel {
    if (!_introLabel) {
        _introLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.icon.frame),CGRectGetMaxY(self.icon.frame)+10,kScreenWidth-30,CGRectGetHeight(self.counLabel.frame))];
        [AppUtils getConfigueLabel:_introLabel font:BoldFont22 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@""];
    }
    return _introLabel;
}
-(UIImageView *)addressView {
    if (!_addressView) {
        _addressView=[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.introLabel.frame),CGRectGetMaxY(self.introLabel.frame)+15,15,15)];
        _addressView.image =[UIImage imageNamed:@"filter_map"];
    }
    return _addressView;
}
-(UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.addressView.frame)+5,CGRectGetMinY(self.addressView.frame)-2,120,16)];
        [AppUtils getConfigueLabel:_addressLabel font:PingFangSCRegular14 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"666666"] text:@"北京市"];
    }
    return _addressLabel;
}
-(UILabel *)feeLabel {
    if (!_feeLabel) {
        _feeLabel =[[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-15-100,CGRectGetMinY(self.addressLabel.frame),100,CGRectGetHeight(self.addressLabel.frame))];
        [AppUtils getConfigueLabel:_feeLabel font:PingFangSCRegular14 aliment:NSTextAlignmentRight textcolor:[UIColor colorFromHexString:@"666666"] text:@"包邮"];
    }
    return _feeLabel;
}

-(UIView *)lineV {
    if (!_lineV) {
        _lineV =[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.addressView.frame),CGRectGetMaxY(self.addressLabel.frame)+10,kScreenWidth-15,1)];
        _lineV.backgroundColor =RGB(242,242,242);
    }
    return _lineV;
}
-(UILabel *)selectLabel {
    if (!_selectLabel) {
        _selectLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.lineV.frame),CGRectGetMaxY(self.lineV.frame)+15,200,20)];
        [AppUtils getConfigueLabel:_selectLabel font:BoldFont16 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@"已选择:"];
    }
    return _selectLabel;
}
-(UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(kScreenWidth-15-15,CGRectGetMinY(self.selectLabel.frame),15,20);
        [_rightBtn setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(selectFee:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}
//选择Sku..
-(void)selectFee:(UIButton *)sender {
    if (self.delegete && [self.delegete respondsToSelector:@selector(showSkuView)]) {
        [self.delegete showSkuView];
    }
}
-(void)setResponse:(HKCicleProductResponse *)response {
    _response = response;
    self.counLabel.text =[NSString stringWithFormat:@"%.2lf",response.data.integral];
    self.introLabel.text =response.data.title;
    if (response.data.freight) {
        self.feeLabel.text =[NSString stringWithFormat:@"运费:%zd",response.data.freight];
    }else {
        self.feeLabel.text =@"包邮";
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
