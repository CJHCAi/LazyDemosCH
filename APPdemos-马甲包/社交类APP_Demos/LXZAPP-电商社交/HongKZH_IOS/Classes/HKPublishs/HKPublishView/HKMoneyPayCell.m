//
//  HKMoneyPayCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/19.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMoneyPayCell.h"

@interface HKMoneyPayCell ()
@property (nonatomic, strong)UILabel * monyLabel;
@property (nonatomic, strong)UIImageView *monyView;
@property (nonatomic, strong)UILabel *coinLabel;
@property (nonatomic, strong)UIImageView *coinView;
@property (nonatomic, strong)UILabel *totalLabel;
@end

@implementation HKMoneyPayCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString * introStr =@"发红包 (可选)";
        NSMutableAttributedString * att =[[NSMutableAttributedString alloc] initWithString:introStr];
        [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"666666"] range:NSMakeRange(0,3)];
        [att addAttribute:NSFontAttributeName value:PingFangSCMedium15 range:NSMakeRange(0,3)];
        [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"999999"] range:NSMakeRange(4,4)];
        [att addAttribute:NSFontAttributeName value:PingFangSCMedium15 range:NSMakeRange(4,4)];
        self.textLabel.attributedText = att;
        [self setUI];
    }
    return  self;
}
-(void)setUI {
    [self.contentView addSubview:self.monyLabel];
    [self.contentView addSubview:self.monyView];
    [self.contentView addSubview:self.coinLabel];
    [self.contentView addSubview:self.coinView];
    [self.contentView addSubview:self.totalLabel];
    [self SetSubViews];
}
-(void)SetSubViews{
   //约束布局
    [self.monyLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.monyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-20);
    }];
    [self.monyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(13.5);
        make.right.equalTo(self.monyLabel.mas_left).offset(-1.5);
    }];
    [self.coinLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.coinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.monyView.mas_left).offset(-10);
    }];
    [self.coinView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(12.5);
        make.right.equalTo(self.coinLabel.mas_left).offset(-1.5);
    }];
    [self.totalLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.coinView.mas_left).offset(-5);
    }];
    

}
-(UILabel *)monyLabel {
    if (!_monyLabel) {
        _monyLabel=[[UILabel alloc] init];
        [AppUtils getConfigueLabel:_monyLabel font:PingFangSCRegular14 aliment:NSTextAlignmentRight textcolor:RGB(51,51,51) text:@""];
    }
    return _monyLabel;
}
-(UIImageView *)monyView {
    if (!_monyView) {
        _monyView =[[UIImageView alloc] init];
        _monyView.image =[UIImage imageNamed:@"lk_hb_01"];
    }
    return _monyView;
}
-(UILabel *)coinLabel {
    if (!_coinLabel) {
        _coinLabel =[[UILabel alloc] init];
        [AppUtils getConfigueLabel:_coinLabel font:PingFangSCRegular14 aliment:NSTextAlignmentRight textcolor:RGB(51,51,51) text:@""];
    }
    return _coinLabel;
}
-(UIImageView *)coinView {
    if (!_coinView) {
        _coinView =[[UIImageView alloc] init];
        _coinView.image =[UIImage imageNamed:@"sp_lb"];
    }
    return _coinView;
}
-(UILabel *)totalLabel {
    if (!_totalLabel) {
        _totalLabel =[[UILabel alloc] init];
        [AppUtils getConfigueLabel:_totalLabel font:PingFangSCRegular14 aliment:NSTextAlignmentRight textcolor:RGB(51,51,51) text:@"共"];
    }
    return _totalLabel;
}
-(void)setModel:(HKMoneyModel *)model {
    if (model.money.length > 0) {
        self.monyLabel.hidden =NO;
        self.monyView.hidden =NO;
        self.coinLabel.hidden =NO;
        self.coinView.hidden =NO;
        self.totalLabel.hidden =NO;
    }else {
        self.monyLabel.hidden =YES;
        self.monyView.hidden  =YES;
        self.coinLabel.hidden =YES;
        self.coinView.hidden = YES;
        self.totalLabel.hidden =YES;
    }
    self.monyLabel.text =model.number;
    self.coinLabel.text =[NSString stringWithFormat:@"%zd;",model.totalMoney];
    [self  SetSubViews];
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
