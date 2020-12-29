//
//  HK_RowFundCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_RowFundCell.h"

@implementation HK_RowFundCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.lineV];
        [self.contentView addSubview:self.tagLabel];
        [self.contentView addSubview:self.textInput];
        [self.contentView addSubview:self.imageRow];
    }
    return  self;
}

-(UIView *)lineV {
    if (!_lineV) {
        _lineV =[[UIView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,0.6)];
        _lineV.backgroundColor =[UIColor colorFromHexString:@"e2e2e2"];
    }
    return _lineV;
}

-(UILabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel =[[UILabel alloc] initWithFrame:CGRectMake(15,0,80,60)];
        [AppUtils getConfigueLabel:_tagLabel font:PingFangSCRegular15 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@"退款类型:"];
        
    }
    return _tagLabel;
}
-(UITextField *)textInput {
    if (!_textInput) {
        _textInput =[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.tagLabel.frame)+8,CGRectGetMinY(self.tagLabel.frame),180,CGRectGetHeight(self.tagLabel.frame))];
        _textInput.borderStyle= UITextBorderStyleNone;
        _textInput.font =PingFangSCRegular15;
        _textInput.textColor =[UIColor colorFromHexString:@"333333"];
        [_textInput setValue:[UIColor colorFromHexString:@"cccccc"] forKeyPath:@"_placeholderLabel.textColor"];
        [_textInput setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
        
    }
    return _textInput;
}

-(UIImageView *)imageRow {
    if (!_imageRow) {
        _imageRow =[[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-15-20,24,20,16)];
        _imageRow.image =[UIImage imageNamed:@"list_right"];
    }
    return _imageRow;
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
