//
//  HKRealNamePhotoCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKRealNamePhotoCell.h"
@interface HKRealNamePhotoCell ()



@end
@implementation HKRealNamePhotoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor =[UIColor whiteColor];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.coverImageV];
        [self.coverImageV addSubview:self.centerImageV];
        [self.coverImageV addSubview:self.messageLabel];
        
    }
    return  self;
    
}
-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(15,15,120,20)];
        [AppUtils getConfigueLabel:_titleLabel font:PingFangSCRegular15 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@""];
        
    }
    return _titleLabel;
}
-(UIImageView *)coverImageV {
    if (!_coverImageV) {
        _coverImageV =[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame),CGRectGetMaxY(self.titleLabel.frame)+15,kScreenWidth-30,160)];
        _coverImageV.image =[UIImage imageNamed:@"smrz_bg"];
        _coverImageV.clipsToBounds =YES;
        _coverImageV.contentMode = UIViewContentModeScaleAspectFill;

    }
    return _coverImageV;
    
}
-(UIImageView *)centerImageV {
    if (!_centerImageV) {
        UIImage * ceterM =[UIImage imageNamed:@"smrz_tj"];
        CGFloat W  =ceterM.size.width;
        CGFloat H  =ceterM.size.height;
        CGFloat RW = CGRectGetWidth(self.coverImageV.frame);
        CGFloat RH = CGRectGetHeight(self.coverImageV.frame);
        _centerImageV =[[UIImageView alloc] initWithFrame:CGRectMake(RW/2-W/2,RH/2-H/2,ceterM.size.width, ceterM.size.height)];
        _centerImageV.image =ceterM;
    }
    return _centerImageV;
    
}
-(UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel =[[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetHeight(self.coverImageV.frame)-15-10,CGRectGetWidth(self.coverImageV.frame),10)];
        [AppUtils getConfigueLabel:_messageLabel font:PingFangSCRegular9 aliment:NSTextAlignmentCenter textcolor:[UIColor colorFromHexString:@"666666"] text:@"请确保证件正面置于胸前拍照,正脸与证件信息均在照片内可以识别"];
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
