//
//  HKPostCommitCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKPostCommitCell.h"

@interface HKPostCommitCell ()

@property (nonatomic, weak)UIImageView *cicleHeadView;

@property (nonatomic, weak)UILabel *cicleNameLabel;

@property (nonatomic, weak)UILabel *cicleDetailLabel;
//点赞按钮
@property (nonatomic, weak)UIButton * praiseBtn;
//评论按钮
@property (nonatomic, weak)UIButton * commitBtn;
//举报按钮
@property (nonatomic, weak)UIButton *reportBtn;
//查看更多
@property (nonatomic, strong)UIButton *checkMore;
@property (nonatomic, weak)UIView *line;
//评论回复列表
@property (nonatomic, strong)UILabel *replayLabel;
@property (nonatomic, strong)UIView *secLine;

@end


@implementation HKPostCommitCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor =[UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return  self;
}

-(UIImageView *)cicleHeadView {
    if (!_cicleHeadView) {
        UIImageView *cicleHeadView =[[UIImageView alloc] init];
        cicleHeadView.image =[UIImage imageNamed:@"Man"];
        [self.contentView addSubview:cicleHeadView];
        _cicleHeadView = cicleHeadView;
        UITapGestureRecognizer *tapClik =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerClick)];
        _cicleHeadView.userInteractionEnabled =YES;
        [_cicleHeadView addGestureRecognizer:tapClik];
    }
    return _cicleHeadView;
}

-(void)headerClick {
    if (self.delegete && [self.delegete respondsToSelector:@selector(pushUserDetailWithModel:)]) {
        [self.delegete pushUserDetailWithModel:self.model];
    }
}
-(UILabel *)cicleNameLabel {
    if (!_cicleNameLabel) {
        UILabel *cicleNameLabel =[[UILabel alloc] init];
        [AppUtils getConfigueLabel:cicleNameLabel font:PingFangSCRegular14 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@""];
        cicleNameLabel.numberOfLines =0;
        [self.contentView addSubview:cicleNameLabel];
        _cicleNameLabel = cicleNameLabel;
    }
    return _cicleNameLabel;
}
-(UILabel *)cicleDetailLabel {
    if (!_cicleDetailLabel) {
        UILabel *cicleDetal=[[UILabel alloc] init];
        [AppUtils getConfigueLabel:cicleDetal font:PingFangSCRegular9 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"7b7b7b"] text:@""];
        [self.contentView addSubview:cicleDetal];
        _cicleDetailLabel = cicleDetal;
    }
    return _cicleDetailLabel;
}

-(UILabel *)replayLabel {
    if (!_replayLabel) {
        UILabel *repl =[[UILabel alloc] init];
        [AppUtils getConfigueLabel:repl font:PingFangSCRegular14 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@""];
        [self.contentView addSubview:repl];
        repl.numberOfLines = 0;
        repl.hidden =YES;
        _replayLabel = repl;
    }
    return _replayLabel;
}
-(UIButton *)commitBtn {
    if (!_commitBtn) {
        UIButton *shareB =[UIButton buttonWithType:UIButtonTypeCustom];
        shareB.frame = CGRectZero;
        [shareB setImage:[UIImage imageNamed:@"gladlyShare"] forState:UIControlStateNormal];
        [AppUtils getButton:shareB font:PingFangSCRegular11 titleColor:[UIColor colorFromHexString:@"7b7b7b"] title:@""];
        shareB.tag =20;
        shareB.backgroundColor =[UIColor colorFromHexString:@"ffffff"];
        [shareB addTarget:self action:@selector(sharePost:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:shareB];
        _commitBtn = shareB;
    }
    return _commitBtn;
}

-(UIButton *)checkMore {
    if (!_checkMore) {
        UIButton *shareB =[UIButton buttonWithType:UIButtonTypeCustom];
        shareB.frame = CGRectZero;
        [AppUtils getButton:shareB font:PingFangSCRegular11 titleColor:[UIColor colorFromHexString:@"4090f7"] title:@"查看更多回复"];
        shareB.tag =40;
        [shareB addTarget:self action:@selector(sharePost:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:shareB];
        _checkMore = shareB;
    }
    return _checkMore;
}

-(UIButton *)reportBtn {
    if (!_reportBtn) {
        UIButton *shareB =[UIButton buttonWithType:UIButtonTypeCustom];
        shareB.frame = CGRectZero;
        [shareB setImage:[UIImage imageNamed:@"buy_more"] forState:UIControlStateNormal];
        shareB.tag =30;
        shareB.backgroundColor =[UIColor colorFromHexString:@"ffffff"];
        [shareB addTarget:self action:@selector(sharePost:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:shareB];
        _reportBtn = shareB; 
    }
    return _reportBtn;
}

-(UIView *)line {
    if (!_line) {
        UIView *line =[[UIView alloc] init];
        line.backgroundColor =[UIColor colorFromHexString:@"eeeeee"];
        [self.contentView addSubview:line];
        _line  =line;
    }
    return _line;
}

-(UIView *)secLine {
    if (!_secLine) {
        UIView *line =[[UIView alloc] init];
        line.backgroundColor =[UIColor colorFromHexString:@"eeeeee"];
        [self.contentView addSubview:line];
        line.hidden =YES;
        _secLine  =line;
    }
    return _secLine;
}
-(void)sharePost:(UIButton *)sender {
    if (self.delegete && [self.delegete respondsToSelector:@selector(ClickCellWithSender:andIndex: withModel:)]) {
        [self.delegete ClickCellWithSender:sender andIndex:sender.tag withModel:self.model];
    }
}
-(UIButton *)praiseBtn {
    if (!_praiseBtn) {
        UIButton *shareB =[UIButton buttonWithType:UIButtonTypeCustom];
        shareB.frame = CGRectZero;
        [shareB setImage:[UIImage imageNamed:@"enterprise_good"] forState:UIControlStateNormal];
        [shareB setImage:[UIImage imageNamed:@"enterprise_goodH"] forState:UIControlStateSelected];
        [AppUtils getButton:shareB font:PingFangSCRegular11 titleColor:[UIColor colorFromHexString:@"7b7b7b"] title:@""];
        shareB.tag =10;
        shareB.backgroundColor =[UIColor colorFromHexString:@"ffffff"];
        [shareB addTarget:self action:@selector(sharePost:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:shareB];
        _praiseBtn = shareB;
    }
    return _praiseBtn;
}
-(void)layoutSubviews {
    [self.cicleHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16);
        make.top.equalTo(self.contentView).offset(20);
        make.width.height.mas_equalTo(36);
    }];
    self.cicleHeadView.layer.cornerRadius =18;
    self.cicleHeadView.layer.masksToBounds =YES;
    
    [self.cicleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cicleHeadView.mas_right).offset(13);
        make.top.equalTo(self.cicleHeadView);
        make.right.equalTo(self.contentView).offset(-16);
        
    }];
    [self.cicleDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cicleNameLabel);
        make.bottom.equalTo(self.cicleHeadView);
        make.height.mas_equalTo(9);
    }];
    
    [self.replayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cicleDetailLabel);
        make.top.equalTo(self.cicleDetailLabel).offset(15);
        make.right.equalTo(self.contentView).offset(-16);
        
    }];

    [self.praiseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cicleNameLabel);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(30);
        make.top.equalTo(self.cicleDetailLabel.mas_bottom).offset(16);
    }];
    [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.praiseBtn);
        make.height.equalTo(self.praiseBtn);
        make.width.mas_equalTo(50);
        make.left.equalTo(self.praiseBtn.mas_right).offset(15);
    }];
    
    [self.reportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-20);
        make.top.equalTo(self.praiseBtn);
        make.width.equalTo(self.praiseBtn);
        make.height.equalTo(self.praiseBtn);
    }];
    
    [self.checkMore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.praiseBtn);
        make.top.equalTo(self.praiseBtn.mas_bottom).offset(15);
        make.width.mas_equalTo(66);
        make.height.mas_equalTo(11);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.praiseBtn);
        make.right.equalTo(self.contentView);
        make.top.equalTo(self.checkMore.mas_bottom).offset(20);
        make.height.mas_equalTo(1);
    }];
    
    
    [self.secLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.praiseBtn);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-1);
        make.height.mas_equalTo(1);
    }];
}
-(void)setModel:(HKCommentList *)model {
    _model = model;
    [AppUtils seImageView:self.cicleHeadView withUrlSting:model.headImg placeholderImage:kPlaceholderHeadImage];
    self.cicleNameLabel.text = model.content;
    self.cicleDetailLabel.text =[NSString stringWithFormat:@"%@ %@",model.uName,model.createDate];
    self.praiseBtn.selected  = model.praiseState.intValue? YES:NO;
    [self.praiseBtn setTitle:[NSString stringWithFormat:@" %@",model.praiseCount] forState:UIControlStateNormal];
    [self.commitBtn setTitle:[NSString stringWithFormat:@" %@",model.commentCount] forState:UIControlStateNormal];
//    if (model.commentCount.integerValue) {
//        self.checkMore.hidden = NO;
//        [self.checkMore setTitle:[NSString stringWithFormat:@"查看 %@ 回复",model.commentCount] forState:UIControlStateNormal];
//    }else {
//        self.checkMore.hidden =YES;
//    }
}
#pragma mark 评论详情..
-(void)setDataModel:(HKCommentInfoData *)dataModel {
    _dataModel = dataModel;
    [AppUtils seImageView:self.cicleHeadView withUrlSting:dataModel.headImg placeholderImage:kPlaceholderHeadImage];
    self.cicleNameLabel.text = dataModel.content;
    self.cicleDetailLabel.text =[NSString stringWithFormat:@"%@ %@",dataModel.uName,dataModel.createDate];
    self.praiseBtn.selected  = dataModel.praiseState.intValue? YES:NO;
    [self.praiseBtn setTitle:[NSString stringWithFormat:@" %@",dataModel.praiseCount] forState:UIControlStateNormal];
    [self.commitBtn setTitle:[NSString stringWithFormat:@" %@",dataModel.commentCount] forState:UIControlStateNormal];
    self.checkMore.hidden =YES;
    self.reportBtn.hidden = YES;
    
}
#pragma mark 评论列表
-(void)setList:(HKReCommentList *)list {
    _list = list;
    self.reportBtn.hidden =YES;
    self.praiseBtn.hidden =YES;
     self.commitBtn.hidden =YES;
    self.checkMore.hidden =YES;
    self.line.hidden =YES;
    self.replayLabel.hidden = NO;
    self.secLine.hidden  = NO;
    [AppUtils seImageView:self.cicleHeadView withUrlSting:list.headImg placeholderImage:kPlaceholderImage];
    self.cicleNameLabel.text =list.uName;
    self.cicleDetailLabel.text =list.createDate;
    NSString * replayStr =[NSString stringWithFormat:@"%@:",self.model.uName];
    NSMutableAttributedString * att =[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"回复%@ %@",replayStr,list.content]];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"4090f7"] range:NSMakeRange(2,replayStr.length)];
    self.replayLabel.attributedText =att;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
