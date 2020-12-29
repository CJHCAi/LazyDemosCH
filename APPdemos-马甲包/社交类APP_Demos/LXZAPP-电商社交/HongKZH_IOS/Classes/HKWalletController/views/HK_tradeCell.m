//
//  HK_tradeCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_tradeCell.h"

@implementation HK_tradeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.shopIm.layer.cornerRadius =2;
    self.shopIm.layer.masksToBounds = YES;
    self.shopIm.image =[UIImage imageNamed:@"p3_2"];
    self.shopIm.contentMode =UIViewContentModeScaleAspectFill;
    self.live.backgroundColor  =RGB(242,242, 242);
    self.tradeTimeLabel.textColor =[UIColor colorFromHexString:@"999999"];
    [self.contentView addSubview:self.countLabel];
   // [self.contentView addSubview:self.imageV];

}
-(UILabel *)countLabel {
    if (!_countLabel) {
//        _countLabel =[[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-15-50,29,50,12)];
          _countLabel =[[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-15-200,25,200,20)];
        [AppUtils getConfigueLabel:_countLabel font:PingFangSCMedium15 aliment:NSTextAlignmentRight textcolor:[UIColor colorFromHexString:@"e66f5c"] text:@"4569"];
    }
    return _countLabel;
}
-(UIImageView *)imageV {
    if (!_imageV) {
        _imageV =[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.countLabel.frame)-2-12,CGRectGetMinY(self.countLabel.frame),12, 12)];
        _imageV.image =[UIImage imageNamed:@"514_goldc_"];
    }
    return _imageV;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configueDataWithModel:(OrderList *)listModel {
    Sublist *subModel = [listModel.subList firstObject];
    self.tradeTimeLabel.text =subModel.currentTime;
    self.tradeNameLabel.text =subModel.title;
    [self.shopIm sd_setImageWithURL:[NSURL URLWithString:subModel.imgSrc]];
    self.countLabel.attributedText = [AppUtils configueLabelAtLeft:YES andCount:subModel.number];
    
    
}
@end
