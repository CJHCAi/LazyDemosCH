//
//  SignInCell.m
//  BasicFW
//
//  Created by zhouyy on 2019/5/10.
//  Copyright © 2019 zyy. All rights reserved.
//

#import "SignInCell.h"




@implementation SignInCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createView];
    }
    return self;
}

- (void)createView{
    
    _leftView = [UIView new];
    _leftView.backgroundColor = UIColorFromRGB(0xE65447);
    _leftView.layer.cornerRadius = 2;
    [self addSubview:_leftView];
    [_leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(50*m6Scale);
        make.centerY.equalTo(self).offset(0*m6Scale);
        make.size.mas_equalTo(CGSizeMake(5, 50*m6Scale));
    }];
    
    _titleLab = [UILabel new];
    _titleLab.text = @"新手任务";
    _titleLab.textColor = UIColorFromRGB(0x303640);
    _titleLab.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:34*m6Scale];
    [self addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(80*m6Scale);
        make.centerY.equalTo(self).offset(0*m6Scale);
    }];
    _titleLab.hidden = YES;
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = BackGroundColor;
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(60*m6Scale);
        make.bottom.equalTo(self).offset(0*m6Scale);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth - 120*m6Scale, 1));
    }];
    
    //不同类型
    _typeLab = [UILabel new];
    _typeLab.text = @"注册奖励";
    _typeLab.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:28*m6Scale];
    _typeLab.textColor = UIColorFromRGB(0x303640);
    [self addSubview:_typeLab];
    [_typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(60*m6Scale);
        make.top.equalTo(self).offset(35*m6Scale);
    }];
    
    
    
    //收缩的内容
    _backHidenView = [UIView new];
    _backHidenView.backgroundColor = BackGroundColor;
    [self addSubview:_backHidenView];
    [_backHidenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(30*m6Scale);
        make.right.equalTo(self).offset(-30*m6Scale);
        make.top.equalTo(self.typeLab.mas_bottom).offset(20*m6Scale);
        make.bottom.equalTo(self);
    }];
    
    //介绍
    _promitLab = [UILabel new];
    _promitLab.text = @"用户首次注册登录接口获得奖励";
    _promitLab.textColor = UIColorFromRGB(0x8495A6);
    _promitLab.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:30*m6Scale];
    _promitLab.numberOfLines = 0;
    _promitLab.textAlignment = NSTextAlignmentLeft;
    [_backHidenView addSubview:_promitLab];
    [_promitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(60*m6Scale);
        make.centerY.equalTo(self.backHidenView);
        make.width.mas_equalTo(kScreenWidth - 300*m6Scale);
    }];
    
    //按钮
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBtn setTitle:@"领取奖励" forState:0];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:30*m6Scale];
    [_rightBtn setTitleColor:UIColorFromRGB(0xFB8C18) forState:0];
    _rightBtn.layer.cornerRadius = 25*m6Scale;
    _rightBtn.layer.borderWidth = 1;
    _rightBtn.layer.borderColor = UIColorFromRGB(0xFB8C18).CGColor;
    
    [_backHidenView addSubview:_rightBtn];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-60*m6Scale);
        make.centerY.equalTo(self.backHidenView);
        make.size.mas_equalTo(CGSizeMake(150*m6Scale, 50*m6Scale));
    }];
    //选择按钮
    _selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_selectedBtn setImage:[UIImage imageNamed:@"task_down"] forState:0];
    [self addSubview:_selectedBtn];
    [_selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-60*m6Scale);
        make.top.equalTo(self).offset(25*m6Scale);
        make.size.mas_equalTo(CGSizeMake(50*m6Scale, 50*m6Scale));
    }];
    //金币
    _glodLab = [UILabel new];
    _glodLab.text = @"+100";
    _glodLab.textColor = UIColorFromRGB(0xFFB92B);
    [self addSubview:_glodLab];
    [_glodLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.selectedBtn.mas_left).offset(-10*m6Scale);
        make.top.equalTo(self).offset(35*m6Scale);
    }];
    
    _goldImagelab = [UILabel new];
    _goldImagelab.text = @"¥";
    _goldImagelab.textColor = [UIColor whiteColor];
    _goldImagelab.backgroundColor = UIColorFromRGB(0xFFB92B);
    _goldImagelab.layer.cornerRadius = 15*m6Scale;
    _goldImagelab.layer.masksToBounds = YES;
    [self addSubview:_goldImagelab];
    [_goldImagelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.glodLab.mas_left).offset(-10*m6Scale);
        make.top.equalTo(self).offset(35*m6Scale);
        make.width.height.mas_equalTo(30*m6Scale);
    }];
    
    
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
