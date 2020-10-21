//
//  HomeFooterCell.m
//  BasicFW
//
//  Created by xxlc on 2019/6/24.
//  Copyright © 2019 zyy. All rights reserved.
//

#import "HomeFooterCell.h"
#import "YSLCustomButton.h"

static NSString *kLinkURL = @"";
static NSString *kLinkTagName = @"";
static NSString *kLinkTitle = @"车主看";
static NSString *kLinkDescription = @"车主看提供丰富的车辆信息";

@implementation HomeFooterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor redColor];
        [self createView];
    }
    return self;
}

- (void)createView{
    _backView = [UIView new];
    _backView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    [self addSubview:_backView];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 100*m6Scale));
    }];
    
    //查看更多按钮
    UIButton *moreBtn = [self commontBtn:@"look_more" title:@"查看全文" type:1];
    moreBtn.tag = 10;
    [moreBtn addTarget:self action:@selector(commont:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:moreBtn];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backView);
        make.top.equalTo(self.backView).offset(30*m6Scale);
    }];
    
    //分享赢好礼
    UILabel *promitLab = [UILabel new];
    promitLab.text = @"分享";
    promitLab.font = [UIFont systemFontOfSize:32*m6Scale];
    promitLab.textColor = UIColorFromRGB(0xF44B50);
    [self addSubview:promitLab];
    [promitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-250*m6Scale);
        make.centerX.equalTo(self);
    }];
    UIView *leftVeiw = [UIView new];
    leftVeiw.backgroundColor = BackGroundColor;
    [self addSubview:leftVeiw];
    [leftVeiw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-270*m6Scale);
        make.right.equalTo(promitLab.mas_left).offset(-20*m6Scale);
        make.size.mas_equalTo(CGSizeMake(100*m6Scale, 1));
    }];
    
    UIView *rightVeiw = [UIView new];
    rightVeiw.backgroundColor = BackGroundColor;
    [self addSubview:rightVeiw];
    [rightVeiw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-270*m6Scale);
        make.left.equalTo(promitLab.mas_right).offset(20*m6Scale);
        make.size.mas_equalTo(CGSizeMake(100*m6Scale, 1));
    }];
    
    //分享
    UIButton *weixinBtn = [self commontBtn:@"hdweixin_icon" title:@"微信好友/群" type:2];
    weixinBtn.tag = 12;
    [weixinBtn addTarget:self action:@selector(shareBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:weixinBtn];
    [weixinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-150*m6Scale);
        make.centerX.equalTo(self).offset(-120*m6Scale);
    }];
    //朋友圈
    UIButton *circleFriendsBtn = [self commontBtn:@"hdpyq_icon" title:@"朋友圈" type:2];
    circleFriendsBtn.tag = 13;
    [circleFriendsBtn addTarget:self action:@selector(shareBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:circleFriendsBtn];
    [circleFriendsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-150*m6Scale);
        make.centerX.equalTo(self).offset(120*m6Scale);
    }];
    
    
    
    //相关推荐
    UIView *lineView = [UIView new];
    lineView.backgroundColor = BackGroundColor;
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.bottom.equalTo(self).offset(-80*m6Scale);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 21*m6Scale));
    }];
    //相关推荐
    UILabel *leftLab = [UILabel new];
    leftLab.text = @"相关推荐";
    leftLab.font = [UIFont systemFontOfSize:30*m6Scale];
    [self addSubview:leftLab];
    [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(30*m6Scale);
        make.bottom.equalTo(self).offset(-20*m6Scale);
    }];
    
    //查看更多
    UIButton *moreListBtn = [self commontBtn:@"p_select_right_icon" title:@"查看更多" type:0];
    [moreListBtn addTarget:self action:@selector(commont:) forControlEvents:UIControlEventTouchUpInside];
    moreListBtn.tag = 11;
    [self addSubview:moreListBtn];
    [moreListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-20*m6Scale);
        make.right.equalTo(self).offset(-30*m6Scale);
    }];
    
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = BackGroundColor;
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.bottom.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5));
    }];
}

- (YSLCustomButton *)commontBtn:(NSString *)imageName title:(NSString *)title type:(NSInteger)tag{
    YSLCustomButton * button = [YSLCustomButton buttonWithType:UIButtonTypeCustom];
    
    button.ysl_spacing = 1*m6Scale;//图片和文字间距
    if (tag == 1) {
        button.ysl_buttonType = YSLCustomButtonImageTop;
        [button setTitleColor:UIColorFromRGB(0x56B4FF) forState:0];
    }else if(tag == 2){
        button.ysl_buttonType = YSLCustomButtonImageTop;
        [button setTitleColor:UIColorFromRGB(0x8688A0) forState:0];
    }else{
        button.ysl_buttonType = YSLCustomButtonImageRight;
        [button setTitleColor:UIColorFromRGB(0x8688A0) forState:0];
    }
    
    button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:26*m6Scale];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    
    
    return button;
}
#pragma mark -分享
- (void)shareBtn:(UIButton *)sender{
    switch (sender.tag) {
        case 12://微信好友
        {
            //                [self smallProgram];//小程序分享
            
        }
            break;
        case 13://微信朋友圈
        {
            
        }
            break;
            
        default:
            break;
    }
}

- (void)commont:(UIButton *)sender{
    self.gotoMoreBtnBlock(sender.tag);
}


@end
