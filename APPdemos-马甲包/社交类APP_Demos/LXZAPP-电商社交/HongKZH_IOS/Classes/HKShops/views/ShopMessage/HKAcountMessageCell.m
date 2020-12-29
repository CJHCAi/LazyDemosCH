//
//  HKAcountMessageCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/30.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKAcountMessageCell.h"

@interface HKAcountMessageCell ()

@property (nonatomic, strong)UILabel * timeLabel;
@property (nonatomic, strong)UIView * backRootView;
@property (nonatomic, strong)UIImageView * cionV;
@property (nonatomic, strong)UILabel *counponLabel;
@property (nonatomic, strong)UILabel *messageLabel;

@end

@implementation HKAcountMessageCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = MainColor
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.backRootView];
        [self.backRootView addSubview:self.cionV];
        [self.backRootView addSubview:self.counponLabel];
        [self.backRootView addSubview:self.messageLabel];
    }
    return  self;
    
}
-(UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel =[[UILabel alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,35)];
        [AppUtils getConfigueLabel:_timeLabel font:PingFangSCRegular12 aliment:NSTextAlignmentCenter textcolor:RGB(153,153,153) text:@"16:24"];
    }
    return _timeLabel;
}
-(UIView *)backRootView {
    if (!_backRootView) {
        _backRootView =[[UIView alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(self.timeLabel.frame),kScreenWidth-30,94)];
        _backRootView.backgroundColor =[UIColor whiteColor];
        _backRootView.layer.cornerRadius =5;
        _backRootView.layer.masksToBounds=YES;
    }
    return _backRootView;
}
-(UIImageView *)cionV {
    if (!_cionV) {
        _cionV =[[UIImageView alloc] initWithFrame:CGRectMake(15,18,60,60)];
        _cionV.image =[UIImage imageNamed:@"wdsc_cnxh_03"];
    }
    return _cionV;
}
-(UILabel *)counponLabel {
    if (!_counponLabel) {
        _counponLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.cionV.frame)+10,CGRectGetMinY(self.cionV.frame),200,15)];
        [AppUtils getConfigueLabel:_counponLabel font:PingFangSCRegular15 aliment:NSTextAlignmentLeft textcolor:RGB(239,89,60) text:@"优惠券到期提醒"];
    }
    return _counponLabel;
}
-(UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.counponLabel.frame),CGRectGetMaxY(self.counponLabel.frame)+10,CGRectGetWidth(self.backRootView.frame)-30-10-60,34)];
        [AppUtils getConfigueLabel:_messageLabel font:PingFangSCRegular12 aliment:NSTextAlignmentLeft textcolor:RGB(153,153,153) text:@"您有一张某商品折扣劵今天到期,购买商品可享7折优惠-戳此查看!"];
        _messageLabel.numberOfLines =0;
    }
    return _messageLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   
}

@end
