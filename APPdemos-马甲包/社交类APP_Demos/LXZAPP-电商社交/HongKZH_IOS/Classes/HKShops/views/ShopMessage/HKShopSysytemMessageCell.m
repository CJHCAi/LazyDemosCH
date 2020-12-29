//
//  HKShopSysytemMessageCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/30.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKShopSysytemMessageCell.h"

@interface HKShopSysytemMessageCell ()
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UIView * backRootView;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIView *line;
@property (nonatomic, strong)UIImageView * icon;
@property (nonatomic, strong)UILabel *subTitleLabel;
@property (nonatomic, strong)UILabel *infoLabel;
@end

@implementation HKShopSysytemMessageCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = MainColor
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.backRootView];
        [self.backRootView addSubview:self.titleLabel];
        [self.backRootView addSubview:self.line];
        [self.backRootView  addSubview:self.icon];
        [self.backRootView addSubview:self.subTitleLabel];
        [self.backRootView addSubview:self.infoLabel];
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
        _backRootView =[[UIView alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(self.timeLabel.frame),kScreenWidth-30,135)];
        _backRootView.backgroundColor =[UIColor whiteColor];
        _backRootView.layer.cornerRadius =5;
        _backRootView.layer.masksToBounds=YES;
    }
    return _backRootView;
}
-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(15,0,kScreenWidth-60,40)];
        [AppUtils getConfigueLabel:_titleLabel font:PingFangSCRegular15 aliment:NSTextAlignmentLeft textcolor:RGB(239,89,60) text:@"科比迪官方旗舰店客服"];
    }
    return _titleLabel;
}
-(UIView *)line {
    if (!_line) {
        _line =[[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.titleLabel.frame),kScreenWidth-30,1)];
        _line.backgroundColor   =RGB(226,226,226);
    }
    return _line;
}
-(UIImageView *)icon {
    if (!_icon) {
        _icon =[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame    ),CGRectGetMaxY(self.line.frame)+15,60,60)];
        _icon.image =[UIImage imageNamed:@"wdsc_cnxh_03"];
    }
    return _icon;
}
-(UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.icon.frame)+10,CGRectGetMinY(self.icon.frame),230,14)];
        [AppUtils getConfigueLabel:_subTitleLabel font:PingFangSCRegular14 aliment:NSTextAlignmentLeft textcolor:RGB(51,51,51) text:@"科比迪官方旗舰店客服"];
    }
    return _subTitleLabel;
}
-(UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.subTitleLabel.frame),CGRectGetMaxY(self.subTitleLabel.frame)+10,CGRectGetWidth(self.backRootView.frame)-30-10-60,34)];
        _infoLabel.numberOfLines =0;
         [AppUtils getConfigueLabel:_infoLabel font:PingFangSCRegular12 aliment:NSTextAlignmentLeft textcolor:RGB(153,153,153) text:@"这次活动,召集时间短,但参加车友多,大家这次很活跃很配合,这就是车友会大家庭温馨吧..."];
    }
    return _infoLabel;
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
