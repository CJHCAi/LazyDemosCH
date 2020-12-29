//
//  HKColageFriendCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/30.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKColageFriendCell.h"

@interface HKColageFriendCell ()
@property (nonatomic, strong)UIImageView *backView;
@property (nonatomic, strong)UIImageView *cornerV;
@property (nonatomic, strong)UIImageView *goodV;
@property (nonatomic, strong)UILabel * titleLabel;
@property (nonatomic, strong)UIImageView * coinV;
@property (nonatomic, strong)UILabel * countLabel;
@property (nonatomic, strong)UILabel *dateLabel;

@end

@implementation HKColageFriendCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor =[UIColor whiteColor];
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.goodV];
        [self.backView addSubview:self.titleLabel];
        [self.backView addSubview:self.coinV];
        [self.backView addSubview:self.countLabel];
        [self.backView addSubview:self.dateLabel];
        [self.backView addSubview:self.cornerV
         ];
    }
    return self;
    
}
-(UIImageView *)backView {
    if (!_backView) {
        _backView =[[UIImageView alloc] initWithFrame:CGRectMake(15,15,kScreenWidth-30,125)];
        _backView.image =[UIImage imageNamed:@"collageBack"];
    }
    return _backView;
}
-(UIImageView *)goodV {
    if (!_goodV) {
        _goodV =[[UIImageView alloc] initWithFrame:CGRectMake(22,35,56,56)];
        _goodV.image =[UIImage imageNamed:@"goodBack"];
    }
    return _goodV;
}
-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.goodV.frame)+22,15,CGRectGetWidth(self.backView.frame)-CGRectGetMaxX(self.goodV.frame)-22-15,50)];
        [AppUtils getConfigueLabel:_titleLabel font:PingFangSCRegular16 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@"高姿净透亮丽肌肤卸妆水失约月色荧光透亮"];
        _titleLabel.numberOfLines =0;
    }
    return _titleLabel;
}
-(UIImageView *)coinV {
    if (!_coinV) {
        _coinV =[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame),CGRectGetMaxY(self.titleLabel.frame)+8,15,15)];
        _coinV.image =[UIImage imageNamed:@"sp_lb"];
    }
    return _coinV;
}
-(UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.coinV.frame)+5,CGRectGetMaxY(self.titleLabel.frame)+5,150,20)];
        _countLabel.numberOfLines =1;
        [AppUtils getConfigueLabel:_countLabel font:PingFangSCRegular20 aliment:NSTextAlignmentLeft textcolor:keyColor text:@"20"];
    }
    return _countLabel;
}
-(UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame),CGRectGetMaxY(self.coinV.frame)+8,CGRectGetWidth(self.titleLabel.frame),16)];
        [AppUtils getConfigueLabel:_dateLabel font:PingFangSCRegular12 aliment:NSTextAlignmentLeft textcolor:RGB(102,102,102) text:@""];
    }
    return _dateLabel;
}
-(void)setResponse:(HKCollageOrderResponse *)response {
     _response  = response;
    if (response.data.discount) {
        self.cornerV.hidden = NO;
        self.cornerV.image =[UIImage imageNamed:[NSString stringWithFormat:@"xrzx_%zdz",response.data.discount]];
    }else {
        self.cornerV.hidden =YES;
    }
    [self.goodV sd_setImageWithURL:[NSURL URLWithString:response.data.imgSrc]];
    self.titleLabel.text = response.data.title;
    self.dateLabel.text =[NSString stringWithFormat:@"有效期: %@-%@",response.data.beginTime,response.data.endTime];
    self.countLabel.text =[NSString stringWithFormat:@"%2.f",response.data.integral];

}
-(UIImageView *)cornerV {
    if (!_cornerV) {
        _cornerV =[[UIImageView alloc] initWithFrame:CGRectMake(0,0,49,49)];
        //_cornerV.image =[UIImage imageNamed:@"xrzx_5z"];
    }
    return _cornerV;
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
