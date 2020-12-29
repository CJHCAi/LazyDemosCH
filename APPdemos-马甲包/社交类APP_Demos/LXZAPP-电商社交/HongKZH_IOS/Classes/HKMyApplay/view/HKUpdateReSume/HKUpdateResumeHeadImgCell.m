//
//  HKUpdateResumeHeadImgCell.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKUpdateResumeHeadImgCell.h"

@interface HKUpdateResumeHeadImgCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation HKUpdateResumeHeadImgCell

- (IBAction)edit:(UIButton *)sender {
    if (self.block) {
        self.block();
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.bgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.bgView.layer.shadowOpacity = 0.5;
    self.bgView.layer.shadowOffset = CGSizeMake(1, 1);
    self.bgView.layer.borderWidth = 1.f;
    self.bgView.layer.borderColor = UICOLOR_HEX(0xdddddd).CGColor;
    
    self.headImgView.layer.cornerRadius = 35;
    self.headImgView.layer.masksToBounds = YES;
    
}

- (void)setHeadImg:(NSString *)headImg {
    if (headImg) {
        _headImg = headImg;
        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:headImg] placeholderImage:[UIImage imageNamed:@"mrtxs2x"]];
    }
}


@end
