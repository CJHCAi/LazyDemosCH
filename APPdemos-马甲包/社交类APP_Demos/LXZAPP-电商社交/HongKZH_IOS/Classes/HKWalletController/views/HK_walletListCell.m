//
//  HK_walletListCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_walletListCell.h"

@implementation HK_walletListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
     if (self) {
         self.selectionStyle = UITableViewCellSelectionStyleNone;
         [self.contentView addSubview:self.itemsLabel];
         [self.contentView addSubview:self.timeLabel];
         [self.contentView addSubview:self.countV];
         [self.contentView addSubview:self.countLabel];
         [self.contentView addSubview:self.lineV];
    }
    return  self;
}
-(UILabel *)itemsLabel {
    if (!_itemsLabel) {
        _itemsLabel =[[UILabel alloc] initWithFrame:CGRectMake(15,15,300,15)];
        [AppUtils getConfigueLabel:_itemsLabel font:PingFangSCRegular15 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@"观看广告奖励"];
        _itemsLabel.numberOfLines =1;
    }
    return _itemsLabel;
}

-(UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.itemsLabel.frame),CGRectGetMaxY(self.itemsLabel.frame)+10,CGRectGetWidth(self.itemsLabel.frame),12)];
        [AppUtils getConfigueLabel:_timeLabel font:PingFangSCRegular12 aliment:NSTextAlignmentLeft textcolor:RGB(153,153,153)  text:@"2018.07.30 14:51:05"];
    }
    return _timeLabel;
}
-(UIImageView *)countV {
    if (!_countV) {
        UIImage * image =[UIImage imageNamed:@"yhq_lb"];
        
        _countV =[[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-15-image.size.width,67/2-image.size.height/2,image.size.width,image.size.height)];
        _countV.image = image;
    }
    return _countV;
}

-(UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.countV.frame)-5-120,23,120,21)];
        [AppUtils getConfigueLabel:_countLabel font:[UIFont boldSystemFontOfSize:15] aliment:NSTextAlignmentRight textcolor:keyColor text:@"+435"];
    }
    return _countLabel;
}
-(UIView *)lineV {
    if (!_lineV) {
        _lineV =[[UIView alloc] initWithFrame:CGRectMake(0,66,kScreenWidth,1)];
        _lineV.backgroundColor =RGB(226,226,226);
    }
    return _lineV;
}
-(void)setDataWithModel:(WalletList *)listModel {
    self.logModel  =listModel;
    if (listModel.remarks.length) {
        self.itemsLabel.text =listModel.remarks;
    }else {
        self.itemsLabel.text =@"无明确明细";
    }
    self.timeLabel.text =listModel.createDate;
    if ([listModel.type isEqualToString:@"1"]) {
        
        self.countLabel.text =[NSString stringWithFormat:@"+%ff",listModel.integral];
    }else {
        
        self.countLabel.text =[NSString stringWithFormat:@"%.2f",listModel.integral];
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
