//
//  HKPostDetailHeadView.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKPostDetailHeadView.h"
#import "HKPostCicleView.h"
@interface HKPostDetailHeadView ()<PreGoCiCleDelegete,UIWebViewDelegate>
//帖子名称
@property (nonatomic, weak)UILabel * postNameLabel;
//发帖人头像
@property (nonatomic, weak)UIImageView * posterHeadView;
//发帖人姓名
@property (nonatomic, weak)UILabel * postUserNameLabel;
//圈子名称+发布时间
@property (nonatomic, weak)UILabel * cicleNameLabel;
////发布的文字内容..
@property (nonatomic, weak)UILabel *containerView;

@property (nonatomic, weak)UIWebView * webView;
//分享按钮
@property (nonatomic, weak)UIButton * shareBtn;
//点赞按钮
@property (nonatomic, weak)UIButton * praiseBtn;
//圈子图
@property (nonatomic, weak)HKPostCicleView * cilceView;
@end

@implementation HKPostDetailHeadView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self =[super initWithFrame:frame]) {
        self.backgroundColor =[UIColor whiteColor];
        self.userInteractionEnabled = YES;
    }
    return  self;
}
-(UILabel *)postNameLabel {
    if (!_postNameLabel) {
        UILabel *post =[[UILabel alloc] init];
        [AppUtils getConfigueLabel:post font:BoldFont20 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@""];
        [self addSubview:post];
        _postNameLabel = post;
    }
    return _postNameLabel;
}
-(UIImageView *)posterHeadView {
    if (!_posterHeadView) {
        UIImageView *postH =[[UIImageView alloc] init];
        postH.image = kPlaceholderHeadImage;
        [self addSubview:postH];
        _posterHeadView = postH;
    }
    return _posterHeadView;
}
-(UILabel *)postUserNameLabel {
    if (!_postUserNameLabel) {
        UILabel *postU =[[UILabel alloc] init];
        [AppUtils getConfigueLabel:postU font:PingFangSCRegular13 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@""];
        [self addSubview:postU];
        _postUserNameLabel = postU;
    }
    return _postUserNameLabel;
}
-(UILabel *)cicleNameLabel {
    if (!_cicleNameLabel) {
        UILabel * cicleName =[[UILabel alloc] init];
        [AppUtils getConfigueLabel:cicleName font:PingFangSCRegular10 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"999999"] text:@""];
        [self addSubview:cicleName];
        _cicleNameLabel = cicleName;
    }
    return _cicleNameLabel;
}
-(UILabel *)containerView {
    if (!_containerView) {
        UILabel * content =[[UILabel alloc] init];
        [AppUtils getConfigueLabel:content font:PingFangSCRegular15 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@""];
        content.numberOfLines =0;
        [content sizeToFit];
        [self addSubview:content];
        _containerView = content;
    }
    return _containerView;
}

-(UIWebView *)webView {
    if (!_webView) {
        UIWebView * wb =[[UIWebView alloc] init];
        wb.delegate = self;
        
        
        
    }
    return _webView;
}



-(UIButton *)shareBtn {
    if (!_shareBtn) {
        UIButton *shareB =[UIButton buttonWithType:UIButtonTypeCustom];
        shareB.frame = CGRectZero;
        [shareB setImage:[UIImage imageNamed:@"group_share"] forState:UIControlStateNormal];
        [AppUtils getButton:shareB font:PingFangSCRegular11 titleColor:[UIColor colorFromHexString:@"7b7b7b"] title:@"分享"];
        shareB.layer.cornerRadius =18;
        shareB.layer.masksToBounds = YES;
        shareB.borderColor =[UIColor colorFromHexString:@"cccccc"];
        shareB.borderWidth =1;
        shareB.tag =20;
        shareB.backgroundColor =[UIColor colorFromHexString:@"ffffff"];
        [shareB addTarget:self action:@selector(sharePost:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:shareB];
        _shareBtn = shareB;
    }
    return _shareBtn;
}
-(void)sharePost:(UIButton *)sender {
    if (self.delegete && [self.delegete respondsToSelector:@selector(setClickBtnWithSender:andTag:)]) {
        [self.delegete setClickBtnWithSender:sender andTag:sender.tag];
    }
}
-(UIButton *)praiseBtn {
    if (!_praiseBtn) {
        UIButton *shareB =[UIButton buttonWithType:UIButtonTypeCustom];
        shareB.frame = CGRectZero;
        [shareB setImage:[UIImage imageNamed:@"wshc_5741"] forState:UIControlStateNormal];
        [shareB setImage:[UIImage imageNamed:@"yshc_5742"] forState:UIControlStateSelected];
        [AppUtils getButton:shareB font:PingFangSCRegular11 titleColor:[UIColor colorFromHexString:@"7b7b7b"] title:@""];
        shareB.layer.cornerRadius =18;
        shareB.layer.masksToBounds = YES;
        shareB.borderColor =[UIColor colorFromHexString:@"cccccc"];
        shareB.borderWidth =1;
        shareB.tag =30;
        shareB.backgroundColor =[UIColor colorFromHexString:@"ffffff"];
        [shareB addTarget:self action:@selector(sharePost:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:shareB];
        _praiseBtn = shareB;
    }
    return _praiseBtn;
}
-(HKPostCicleView *)cilceView {
    if (!_cilceView) {
        HKPostCicleView * cicle =[[HKPostCicleView alloc] init];
        cicle.delegete = self;
        [self addSubview:cicle];
        _cilceView = cicle;
    }
    return _cilceView;
}

-(void)pushCilce {
    if (self.delegete && [self.delegete respondsToSelector:@selector(enterCicleVc)]) {
        [self.delegete enterCicleVc];
    }
}
-(void)layoutSubviews {
    [self.postNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.top.equalTo(self).offset(20);
        make.height.mas_equalTo(20);
    }];
    [self.posterHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.postNameLabel);
        make.top.equalTo(self.postNameLabel.mas_bottom).offset(35);
        make.height.width.mas_equalTo(30);
        
    }];
    self.posterHeadView.layer.cornerRadius =15;
    self.posterHeadView.layer.masksToBounds = YES;
    
    [self.postUserNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.posterHeadView.mas_right).offset(10);
        make.top.equalTo(self.posterHeadView);
        make.height.mas_equalTo(13);
    }];
    [self.cicleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.postUserNameLabel);
        make.bottom.equalTo(self.posterHeadView);
        make.height.mas_equalTo(10);
    }];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.posterHeadView);
        make.top.equalTo(self.posterHeadView.mas_bottom).offset(23);
        make.width.mas_equalTo(kScreenWidth-32);
    }];
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(115);
        make.height.mas_equalTo(35);
        make.top.equalTo(self.containerView.mas_bottom).offset(25);
        make.centerX.equalTo(self).offset(-8-115/2);
    }];
    [self.praiseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.shareBtn);
        make.height.equalTo(self.shareBtn);
        make.top.equalTo(self.shareBtn);
        make.centerX.equalTo(self).offset(8+115/2);
    }];
    self.praiseBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [self.cilceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.posterHeadView);
        make.top.equalTo(self.shareBtn.mas_bottom).offset(26);
        make.right.equalTo(self).offset(-16);
        make.height.mas_equalTo(70);
    }];
    self.headH = CGRectGetMaxY(self.cilceView.frame)+55;
    
}
-(void)setHeadDataWithResponse:(HKPostDetailResponse *)response {
    _response = response;
    self.postNameLabel.text = response.data.title;
    [AppUtils seImageView:self.posterHeadView withUrlSting:response.data.headImg placeholderImage:kPlaceholderHeadImage];
    self.postUserNameLabel.text =response.data.uName;
    self.cicleNameLabel.text =[NSString stringWithFormat:@"%@ %@",response.data.name,response.data.createDate];
   // self.containerView.text =response.data.content;
    if (response.data.imgList.count) {
       //用Web..
    }else {
        
    }
    if (response.data.isPraise.intValue) {
        self.praiseBtn.selected =YES;
    }else {
        self.praiseBtn.selected = NO;
    }
    [self.praiseBtn setTitle:response.data.praiseCount forState:UIControlStateNormal];
    self.cilceView.response = response;

}
@end
