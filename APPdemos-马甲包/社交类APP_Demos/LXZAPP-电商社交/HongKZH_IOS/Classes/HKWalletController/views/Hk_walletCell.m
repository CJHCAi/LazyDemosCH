//
//  Hk_walletCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "Hk_walletCell.h"

@implementation Hk_walletCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.iconImageV];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.rightRow];
           [self.contentView addSubview:self.countLabel];
       // [self.contentView addSubview:self.countIm];
     
    }
    return  self;
    
}
-(UIImageView *)iconImageV {
    if (!_iconImageV) {
        _iconImageV =[[UIImageView alloc] initWithFrame:CGRectMake(17,15,16,14)];
        _iconImageV.backgroundColor =[UIColor cyanColor];
    }
    return  _iconImageV;
}
-(UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageV.frame)+5,0,120,44)];
        [AppUtils getConfigueLabel:_nameLabel font:PingFangSCRegular15 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@""];
        
        
    }
    return _nameLabel;
}
-(UIImageView *)rightRow {
    if (!_rightRow) {
        _rightRow =[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH_S-12-14,15,16,14)];
        _rightRow.image  =[UIImage imageNamed:@"list_right"];
    }
    return _rightRow;
}

-(UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.rightRow.frame)-200-3,CGRectGetMinY(self.nameLabel.frame),200,CGRectGetHeight(self.nameLabel.frame))];
                [AppUtils getConfigueLabel:_countLabel font:PingFangSCMedium14 aliment:NSTextAlignmentRight textcolor:[UIColor colorFromHexString:@"f76654"] text:@"7560"];
        _countLabel.hidden = YES;
    }
    return _countLabel;
}
-(UIImageView *)countIm {
    if (!_countIm) {
        _countIm =[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.countLabel.frame)-10-3,CGRectGetMinY(self.countLabel.frame)+16,12,12)];
        
        UIImage * image =[UIImage imageNamed:@"514_goldc_"];
        _countIm.image = image;
        _countIm.hidden = YES;
    }
    return _countIm;
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
