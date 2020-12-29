//
//  HKCityTravelsTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCityTravelsTableViewCell.h"
#import "HKImageAndTitleBtn.h"
#import "HKMyPostNameView.h"
#import "HKMyPostViewModel.h"
#import "ZSUserHeadBtn.h"
#import "UIImageView+HKWeb.h"
#import "UIButton+ZSYYWebImage.h"
@interface HKCityTravelsTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconVIew;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet ZSUserHeadBtn *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *leB;
@property (weak, nonatomic) IBOutlet UILabel *titleVIew;
@property (weak, nonatomic) IBOutlet UILabel *zhuanLabel;
@property (weak, nonatomic) IBOutlet UIImageView *leBicon;

@end

@implementation HKCityTravelsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[VersionAuditStaueTool sharedVersionAuditStaueTool]isAuditAdopt]) {
        self.zhuanLabel.hidden = NO;
        self.leBicon.hidden = NO;
        self.leB.hidden = NO;
    }else{
        self.zhuanLabel.hidden = YES;
        self.leBicon.hidden = YES;
        self.leB.hidden = YES;
    }
}
-(void)setRespone:(HKCityTravelsRespone *)respone{
    _respone = respone;
    [self.iconVIew hk_sd_setImageWithURL:respone.data.coverImgSrc placeholderImage:kPlaceholderImage];
    [self.headBtn hk_setBackgroundImageWithURL:respone.data.headImg forState:0 placeholder:kPlaceholderHeadImage];
    self.descLabel.text = [NSString stringWithFormat:@"游记⋅%@",respone.data.createDate];
    self.name.text = respone.data.name;
    self.leB.text = [NSString stringWithFormat:@"%@",respone.data.rewardCount];
    self.titleVIew.text = respone.data.title;
}
@end
