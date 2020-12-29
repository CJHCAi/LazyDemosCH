//
//  HK_orderAddressCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_orderAddressCell.h"

@implementation HK_orderAddressCell
{
    UIView * _rootView;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.backImageView];
        [self.contentView addSubview:self.rootView];
        [self.rootView  addSubview:self.nameLabel];
        [self.rootView addSubview:self.phoneLabel];
        [self.rootView addSubview:self.addressLabel];
        [self.rootView addSubview:self.editAddressBtn];
  
        [self layoutSubviews];
    }
    return  self;
}

-(UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView =[[UIImageView alloc] init];
        _backImageView.image =[UIImage imageNamed:@"511_pic_confirmorder"];
    }
    return _backImageView;
}

-(UIView *)rootView {
    if (!_rootView) {
        _rootView =[[UIView alloc] init];
        _rootView.backgroundColor =[UIColor colorFromHexString:@"fffde5"];
    }
    return _rootView;
}


-(UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel =[[UILabel alloc] init];
        [AppUtils getConfigueLabel:_nameLabel font:PingFangSCMedium15 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@"赵先生"];
    }
    return _nameLabel;
}
-(UILabel *)phoneLabel {
    if (!_phoneLabel) {
        _phoneLabel =[[UILabel alloc] init];
        [AppUtils getConfigueLabel:_phoneLabel font:PingFangSCMedium15 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@"136****4416"];
        
    }
    return _phoneLabel;
}
-(UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel =[[UILabel alloc] init];
        [AppUtils getConfigueLabel:_addressLabel font:PingFangSCMedium13 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"666666"] text:@"北京市朝阳区建外SOHO12号楼903室"];
    }
    return _addressLabel;
}

-(UIButton *)editAddressBtn {
    if (!_editAddressBtn) {
        
        _editAddressBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _editAddressBtn.hidden = YES;
        [_editAddressBtn addTarget:self action:@selector(editAddress) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editAddressBtn;
}
//编辑地址
-(void)editAddress {
    if (self.delegete && [self.delegete respondsToSelector:@selector(editGoodsAddress)]) {
        [self.delegete editGoodsAddress];
    }
}
-(void)setCellConfigueWithModel:(HK_orderInfo *)model {
    
    self.nameLabel.text = model.data.address.consignee;
    self.phoneLabel.text =model.data.address.phone;
    self.addressLabel.text = model.data.address.address;
    if ([model.data.state isEqualToString:@"7"] || [model.data.state isEqualToString:@"8"]||[model.data.state isEqualToString:@"10"]) {
      //完成 取消 不能 编辑地址..
        self.editAddressBtn.hidden =YES;
    }else {
        self.editAddressBtn.hidden = NO;
    }
  //  NSString *phoneStr = model.data.address.phone;
//    NSString *preStr  =[phoneStr substringWithRange:NSMakeRange(0,3)];
//    NSString *lastStr =[phoneStr substringWithRange:NSMakeRange(7,4)];
//    self.phoneLabel.text =[NSString stringWithFormat:@"%@****%@",preStr,lastStr];
}

-(void)layoutSubviews {
    self.backImageView.frame =CGRectMake(0,0,kScreenWidth,5);
    self.rootView.frame =CGRectMake(0,CGRectGetMaxY(self.backImageView.frame),CGRectGetWidth(self.backImageView.frame),65);
    self.nameLabel.frame = CGRectMake(16,15,80,20);
    self.phoneLabel.frame = CGRectMake(CGRectGetMaxX(self.nameLabel.frame)+5,CGRectGetMinY(self.nameLabel.frame),120,CGRectGetHeight(self.nameLabel.frame));
    self.addressLabel.frame = CGRectMake(CGRectGetMinX(self.nameLabel.frame),CGRectGetMaxY(self.nameLabel.frame),kScreenWidth-32,CGRectGetHeight(self.nameLabel.frame));
    UIImage *editIm =[UIImage imageNamed:@"dynamic_write"];
    self.editAddressBtn.frame = CGRectMake(kScreenWidth-editIm.size.width-15,65/2-editIm.size.height/2,editIm.size.width,editIm.size.height);
    [self.editAddressBtn setImage:editIm forState:UIControlStateNormal];
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
