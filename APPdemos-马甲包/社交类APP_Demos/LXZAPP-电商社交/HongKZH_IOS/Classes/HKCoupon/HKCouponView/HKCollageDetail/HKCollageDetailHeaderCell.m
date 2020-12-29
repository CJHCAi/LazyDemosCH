//
//  HKCollageDetailHeaderCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/30.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCollageDetailHeaderCell.h"
#import "HKCounponTool.h"
@interface HKCollageDetailHeaderCell ()
@property (nonatomic, strong)UIView *rootView;
@property (nonatomic, strong)UILabel *messageLabel;
@property (nonatomic, strong)UILabel *detailLabel;
@property (nonatomic, strong)UIImageView * iconleft;
@property (nonatomic, strong)UIImageView *iconRight;
@property (nonatomic, strong)UIButton *invateBtn;
@property (nonatomic, strong)UILabel * tipsLabel;

@end



@implementation HKCollageDetailHeaderCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor =[UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.rootView];
        [self.rootView addSubview:self.messageLabel];
        [self.rootView addSubview:self.detailLabel];
        [self.contentView addSubview:self.iconleft];
        [self.contentView addSubview:self.iconRight];
        [self.contentView addSubview:self.invateBtn];
        [self.contentView addSubview:self.tipsLabel];
    }
    return self;
}

-(UIView *)rootView {
    if (!_rootView) {
        _rootView =[[UIView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,90)];
        _rootView.backgroundColor =RGBA(255,245,243,1);
    }
    return _rootView;
}
-(UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel =[[UILabel alloc] initWithFrame:CGRectMake(15,25,kScreenWidth-30,17)];
        [AppUtils getConfigueLabel:_messageLabel font:[UIFont boldSystemFontOfSize:17] aliment:NSTextAlignmentLeft textcolor:keyColor text:@"拼单还未成功"];
    }
    return _messageLabel;
}
-(UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel =[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.messageLabel.frame),CGRectGetMaxY(self.messageLabel.frame)+10,CGRectGetWidth(self.messageLabel.frame),13)];
        [AppUtils getConfigueLabel:_detailLabel font:PingFangSCRegular13 aliment:NSTextAlignmentLeft textcolor:RGBA(51,51,51,1) text:@"待分享, 还差1人 剩余时: 13:50:46"];
    }
    return _detailLabel;
}

-(UIImageView *)iconleft {
    if (!_iconleft) {
        _iconleft =[[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-10-45,CGRectGetMaxY(self.rootView.frame)+25,45,45)];
        _iconleft.image =[UIImage imageNamed:@"Man"];
        _iconleft.layer.cornerRadius =45/2;
        _iconleft.layer.masksToBounds =YES;
        
    }
    return _iconleft;
}
-(UIImageView *)iconRight {
    if (!_iconRight) {
        _iconRight =[[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2+10,CGRectGetMinY(self.iconleft.frame),CGRectGetWidth(self.iconleft.frame),CGRectGetHeight(self.iconleft.frame))];
        _iconRight.image =[UIImage imageNamed:@"Man"];
        _iconRight.layer.cornerRadius =45/2;
        _iconRight.layer.masksToBounds =YES;
    }
    return _iconRight;
}
-(UIButton *)invateBtn {
    if (!_invateBtn) {
        _invateBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _invateBtn.frame =CGRectMake(kScreenWidth/2-150,CGRectGetMaxY(self.iconleft.frame)+20,300,43);
        [AppUtils getButton:_invateBtn font:[UIFont boldSystemFontOfSize:15] titleColor:[UIColor whiteColor] title:@"邀请好友拼单"];
        _invateBtn.layer.cornerRadius =20;
        _invateBtn.layer.masksToBounds =YES;
        _invateBtn.backgroundColor =keyColor;
        [_invateBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    }
    return _invateBtn;
}

-(void)share {
    if (self.block) {
        self.block();
    }
}
-(UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel =[[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.invateBtn.frame)+15,kScreenWidth,13)];
        [AppUtils getConfigueLabel:_tipsLabel font:PingFangSCRegular13 aliment:NSTextAlignmentCenter textcolor:RGB(102,102,102) text:@"分享给好友,让你的小伙伴们一起来拼单吧"];
    }
    return _tipsLabel;
}

-(void)setResponse:(HKCollageOrderResponse *)response {
    
    _response= response;
    if (response.data.list.count > 1 && response.data.list.count) {
        
        HKCollageList *listOne = [response.data.list firstObject];
        [self.iconleft sd_setImageWithURL:[NSURL URLWithString:listOne.headImg]];
        HKCollageList *listTwo =[response.data.list lastObject];
        [self.iconRight sd_setImageWithURL:[NSURL URLWithString:listTwo.headImg]];
    }else if (response.data.list.count ==1) {
        HKCollageList *listOne = [response.data.list firstObject];
        [self.iconleft sd_setImageWithURL:[NSURL URLWithString:listOne.headImg]];
    }
     NSString *timeStr =[HKCounponTool getConponLastStringWithEndString:response.data.endDate];
    if ([timeStr isEqualToString:@"优惠券已过期"]) {
        self.detailLabel.text = @"拼团时间截止";
    }else {
        self.detailLabel.text =[NSString stringWithFormat:@"待分享, 还差1人 : %@",timeStr];
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
