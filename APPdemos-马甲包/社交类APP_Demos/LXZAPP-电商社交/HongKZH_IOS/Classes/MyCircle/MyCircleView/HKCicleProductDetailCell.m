//
//  HKCicleProductDetailCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/30.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCicleProductDetailCell.h"

@interface HKCicleProductDetailCell ()
@property (nonatomic, strong)UILabel * tagLabel;
@property (nonatomic, strong)UILabel *detailLabel;
@end

@implementation HKCicleProductDetailCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle =UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor =[UIColor whiteColor];
        [self.contentView addSubview:self.tagLabel];
        [self.contentView addSubview:self.detailLabel];
    }
    return  self;
}
-(UILabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel =[[UILabel alloc] initWithFrame:CGRectMake(15,15,kScreenWidth-30,25)];
        [AppUtils getConfigueLabel:_tagLabel font:BoldFont22 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@"商品详情"];
    }
    return _tagLabel;
}
-(UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.tagLabel.frame),CGRectGetMaxY(self.tagLabel.frame)+10,kScreenWidth-30,40)];
        [AppUtils getConfigueLabel:_detailLabel font:PingFangSCRegular15 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@""];
        _detailLabel.numberOfLines =0;
    }
    return _detailLabel;
}

-(void)setRes:(HKCicleProductResponse *)res {
    _res =res;
    self.detailLabel.text = res.data.descript;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
