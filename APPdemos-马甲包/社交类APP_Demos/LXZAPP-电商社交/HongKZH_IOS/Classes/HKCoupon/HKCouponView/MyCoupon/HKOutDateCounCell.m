//
//  HKOutDateCounCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/26.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKOutDateCounCell.h"

@interface HKOutDateCounCell ()

@property (nonatomic, strong)UIImageView * cover;
@property (nonatomic, strong)UILabel * discounLabel;
@property (nonatomic, strong)UILabel * tipsLabel;
@property (nonatomic, strong)UILabel *dateLabel;
@property (nonatomic, strong)UIImageView * outDateView;

@end



@implementation HKOutDateCounCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.cover];
        [self.contentView addSubview:self.discounLabel];
        [self.contentView addSubview:self.tipsLabel];
        [self.contentView addSubview:self.dateLabel];
        [self.contentView addSubview:self.outDateView];
    }
    return self;
}
-(UIImageView *)cover {
    if (!_cover) {
        _cover =[[UIImageView alloc] initWithFrame:CGRectMake(15,15,100,100)];
        _cover.image =[UIImage imageNamed:@"p3_2"];
        _cover.layer.masksToBounds =YES;
        _cover.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _cover;
}
-(UILabel *)discounLabel {
    if (!_discounLabel) {
        _discounLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.cover.frame)+8,CGRectGetMinY(self.cover.frame)+10,80,15)];
        [AppUtils getConfigueLabel:_discounLabel font:PingFangSCMedium15 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@"商品折扣劵"];
    }
    return _discounLabel;
}
-(UILabel *)tipsLabel
{
    if (!_tipsLabel) {
        _tipsLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.discounLabel.frame)+10,CGRectGetMinY(self.discounLabel.frame),120,CGRectGetHeight(self.discounLabel.frame))
                     ];
        [AppUtils getConfigueLabel:_tipsLabel font:PingFangSCRegular13 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"999999"] text:@"仅可在本店铺使使用"];
    }
    return _tipsLabel;
}
-(UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.discounLabel.frame),CGRectGetMaxY(self.discounLabel.frame)+10,300,10)];
        [AppUtils getConfigueLabel:_dateLabel font:PingFangSCRegular13 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"999999"] text:@"使用日期 2018.09.11-2018.11.12"];
    }
    return _dateLabel;
}

-(UIImageView *)outDateView {
    if (!_outDateView) {
        _outDateView =[[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-15-80,CGRectGetMinY(self.tipsLabel.frame),80,80)];
        _outDateView.layer.cornerRadius =40;
        _outDateView.layer.masksToBounds =YES;
        _outDateView.image =[UIImage imageNamed:@"p3_1"];
        
    }
    return _outDateView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
