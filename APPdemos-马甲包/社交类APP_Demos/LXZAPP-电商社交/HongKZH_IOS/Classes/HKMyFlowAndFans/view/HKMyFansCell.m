//
//  HKMyFansCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/9.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyFansCell.h"
#import "HKSexLevelView.h"
#import "UIButton+WebCache.h"

@interface HKMyFansCell ()
@property (weak, nonatomic) IBOutlet UIButton *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet HKSexLevelView *sexLevelView;
@property (weak, nonatomic) IBOutlet UILabel *fansLabel;
@property (weak, nonatomic) IBOutlet UIButton *attentionBution;

@end

@implementation HKMyFansCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.sexLevelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.left.mas_equalTo(self.nameLabel.mas_right).offset(10);
    }];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.headImageView.layer.cornerRadius = 24;
    self.headImageView.layer.masksToBounds = YES;
    
    self.attentionBution.layer.cornerRadius = 4;
    self.attentionBution.layer.masksToBounds = YES;
    self.attentionBution.layer.borderWidth = 1;
}

//关注按钮点击
- (IBAction)attentionButionClick:(UIButton *)sender {
    if ([self.cellValue isKindOfClass:[HKMyFollowsEnterpriseList class]]){
        //如果是我关注的企业不能取消关注(罗哥说的)
        return;
    }
    if (self.attentionButtonClickBlock) {
        self.attentionButtonClickBlock(self.cellValue, self);
    }
}

- (void)setCellValue:(id)cellValue {
    if (cellValue) {
        _cellValue = cellValue;
        if ([cellValue isKindOfClass:[HKMyFollowAndFansList class]]) {
            HKMyFollowAndFansList *value = (HKMyFollowAndFansList *)cellValue;
            if (value.isAttention) {
                self.attentionBution.layer.borderColor = UICOLOR_HEX(0xcccccc).CGColor;
                [self.attentionBution setTitleColor:UICOLOR_HEX(0xcccccc) forState:UIControlStateNormal];
                [self.attentionBution setTitle:@"取消关注" forState:UIControlStateNormal];
            } else {
                self.attentionBution.layer.borderColor = UICOLOR_HEX(0x4090f7).CGColor;
                [self.attentionBution setTitleColor:UICOLOR_HEX(0x4090f7) forState:UIControlStateNormal];
                [self.attentionBution setTitle:@"关注" forState:UIControlStateNormal];
            }
            [self.headImageView sd_setImageWithURL:[NSURL URLWithString:value.headImg] forState:UIControlStateNormal];
            //name
            self.nameLabel.text = value.name;
            //sexLevelView
            self.sexLevelView.sex = [value.sex integerValue];
            self.sexLevelView.level = [NSString stringWithFormat:@"%ld",value.level];
            //fanslabel
            self.fansLabel.text = [NSString stringWithFormat:@"关注 %ld人 | 粉丝 %ld人",value.gcount,value.fcount];
            
        } else if ([cellValue isKindOfClass:[HKMyFollowsEnterpriseList class]]) {
            HKMyFollowsEnterpriseList *value = (HKMyFollowsEnterpriseList *)cellValue;
            if (value.isAttention) {
                self.attentionBution.layer.borderColor = UICOLOR_HEX(0xcccccc).CGColor;
                [self.attentionBution setTitleColor:UICOLOR_HEX(0xcccccc) forState:UIControlStateNormal];
                [self.attentionBution setTitle:@"已关注" forState:UIControlStateNormal];
            } else {
                self.attentionBution.layer.borderColor = UICOLOR_HEX(0x4090f7).CGColor;
                [self.attentionBution setTitleColor:UICOLOR_HEX(0x4090f7) forState:UIControlStateNormal];
                [self.attentionBution setTitle:@"关注" forState:UIControlStateNormal];
            }
            [self.headImageView sd_setImageWithURL:[NSURL URLWithString:value.headImg] forState:UIControlStateNormal];
            //name
            self.nameLabel.text = value.name;
            self.sexLevelView.hidden = YES;
            //fanslabel
            self.fansLabel.text = [NSString stringWithFormat:@"粉丝 %ld人",value.fcount];
        }
    }
}
@end
