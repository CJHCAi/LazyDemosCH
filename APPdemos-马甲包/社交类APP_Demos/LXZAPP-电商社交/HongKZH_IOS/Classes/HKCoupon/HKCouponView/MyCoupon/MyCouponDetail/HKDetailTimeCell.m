//
//  HKDetailTimeCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/1.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKDetailTimeCell.h"
#import "HKCounponTool.h"
@interface HKDetailTimeCell ()
@property (nonatomic, strong)UILabel *timeEndLabel;
@property (nonatomic, strong)UILabel *teamLabel;
@property (nonatomic, strong)UILabel *oneShopLabel;
@end

@implementation HKDetailTimeCell
//50
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle =UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor =[UIColor whiteColor];
        [self.contentView addSubview:self.timeEndLabel];
        [self.contentView addSubview:self.oneShopLabel];
        [self.contentView addSubview:self.teamLabel];
    }
    return  self;
    
}
-(UILabel *)timeEndLabel {
    if (!_timeEndLabel) {
        _timeEndLabel =[[UILabel alloc] initWithFrame:CGRectMake(15,0,160,50)];
        [AppUtils getConfigueLabel:_timeEndLabel font:PingFangSCRegular14 aliment:NSTextAlignmentLeft textcolor:RGB(51,51,51) text:@"距离结束: 13:50:46"];
    }
    return _timeEndLabel;
}
-(UILabel *)teamLabel {
    if (!_teamLabel) {
        _teamLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.oneShopLabel.frame)-5-45,16,45,18)];
        [AppUtils getConfigueLabel:_teamLabel font:PingFangSCRegular12 aliment:NSTextAlignmentCenter textcolor:keyColor text:@"2人团"];
        _teamLabel.layer.cornerRadius  =3;
        _teamLabel.layer.masksToBounds = YES;
        _teamLabel.borderWidth = 1;
        _teamLabel.borderColor =keyColor;
    }
    return _teamLabel;
}
-(UILabel *)oneShopLabel {
    if (!_oneShopLabel) {
        _oneShopLabel =[[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-15-82,0,82,CGRectGetHeight(self.timeEndLabel.frame))];
        [AppUtils getConfigueLabel:_oneShopLabel font:PingFangSCRegular14 aliment:NSTextAlignmentRight textcolor:RGB(102,102,102) text:@""];
        NSString * shopsNumber =@"每人限购1件";
        NSMutableAttributedString * textAtt =[[NSMutableAttributedString alloc] initWithString:shopsNumber];
        [textAtt addAttribute:NSForegroundColorAttributeName value:keyColor range:NSMakeRange(4,1)];
        _oneShopLabel.attributedText = textAtt;
    }
    return _oneShopLabel;
}
//结束时间倒计时
-(void)setEndStr:(NSString *)endStr {
    

    self.timeEndLabel.text =[HKCounponTool getConponLastStringWithEndString:endStr];
    
}
-(void)setTeamNumber:(NSInteger)number {
    self.teamLabel.text =[NSString  stringWithFormat:@"%zd人团",number];
}
-(void)clearText {
    self.timeEndLabel.text =@"";
    self.teamLabel.text =@"";
    self.oneShopLabel.text =@"";
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
