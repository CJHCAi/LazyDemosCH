//
//  HK_shopsDetailCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_shopsDetailCell.h"


@implementation HK_shopsDetailCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor =[UIColor whiteColor];
        [self.contentView addSubview:self.tagLabel];
        [self.contentView addSubview:self.rowImageV];
        [self.contentView addSubview:self.messageLabel];
    }
    return  self;
    
}
-(UILabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel =[[UILabel alloc] initWithFrame:CGRectMake(15,15,180,20)];
        [AppUtils getConfigueLabel:_tagLabel font:PingFangSCRegular15 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@""];
    }
    return _tagLabel;
}
-(UIImageView *)rowImageV {
    if (!_rowImageV) {
        _rowImageV =[[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-15-20,CGRectGetMinY(_tagLabel.frame),20,20)];
        _rowImageV.hidden =YES;
    }
    return _rowImageV;
}
-(UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel =[[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-15-300,CGRectGetMinY(self.tagLabel.frame),300,CGRectGetHeight(self.tagLabel.frame))];
         [AppUtils getConfigueLabel:_messageLabel font:PingFangSCRegular14 aliment:NSTextAlignmentRight textcolor:[UIColor colorFromHexString:@"999999"] text:@""];
        _messageLabel.hidden =YES;
    }
    return _messageLabel;
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
