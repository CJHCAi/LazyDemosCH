//
//  HKAdvertisingVideoUserTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/11/7.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKAdvertisingVideoUserTableViewCell.h"
#import "HKIconAndTitleCenterView.h"
#import "EnterpriseAdvRespone.h"
#import "YYAnimatedImageView.h"
#import "UIImageView+YYWebImage.h"
@interface HKAdvertisingVideoUserTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *descText;
@property (weak, nonatomic) IBOutlet UILabel *nameTitle;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet HKIconAndTitleCenterView *share;
@property (weak, nonatomic) IBOutlet YYAnimatedImageView *giftIcon;
@property (weak, nonatomic) IBOutlet HKIconAndTitleCenterView *save;
@property (weak, nonatomic) IBOutlet HKIconAndTitleCenterView *reportBtn;
@property (nonatomic, strong)NSTimer *timer;
@end

@implementation HKAdvertisingVideoUserTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.share setTitleColor:[UIColor colorFromHexString:@"7b7b7b"] titleFont:PingFangSCMedium11 imageName:@"group_share" backColor:[UIColor whiteColor] title:@""];
    [self.save setTitleColor:[UIColor colorFromHexString:@"7b7b7b"] titleFont:PingFangSCMedium11 imageName:@"ptzx_sc" backColor:[UIColor whiteColor] title:@""];
    [self.reportBtn setTitleColor:[UIColor colorFromHexString:@"7b7b7b"] titleFont:PingFangSCMedium11 imageName:@"dianzan" backColor:[UIColor whiteColor] title:@""];
    @weakify(self)
    self.share.click = ^(HKIconAndTitleCenterView *sender) {
        @strongify(self)
        if ([self.delegate respondsToSelector:@selector(clickWithTag:)]) {
            [self.delegate clickWithTag:self.share.tag];
        }
    };
    self.save.click = ^(HKIconAndTitleCenterView *sender) {
        @strongify(self)
        if ([self.delegate respondsToSelector:@selector(clickWithTag:)]) {
            [self.delegate clickWithTag:self.save.tag];
        }
    };
    self.reportBtn.click = ^(HKIconAndTitleCenterView *sender) {
        @strongify(self)
        if ([self.delegate respondsToSelector:@selector(clickWithTag:)]) {
            [self.delegate clickWithTag:self.reportBtn.tag];
        }
    };
    
}
-(void)setRespone:(EnterpriseAdvRespone *)respone{
    _respone = respone;
    self.nameTitle.text = respone.data.title;
    self.descText.text = [NSString stringWithFormat:@"%@发布・%@次观看",respone.data.createDate,respone.data.playCount] ;
    self.timeLabel.text = [NSString stringWithFormat:@"%lds",respone.videoTime];
    if (respone.isOpen) {
        self.giftIcon.image = [UIImage imageNamed:@"lh_lq"];
    }else{
        NSURL *path = [[NSBundle mainBundle]URLForResource:@"lh_bg@3x" withExtension:@"gif"];
        if (kScreenWidth<375) {
            path = [[NSBundle mainBundle]URLForResource:@"lh_bg@2x" withExtension:@"gif"];
        }
        
        self.giftIcon.yy_imageURL = path;;
    }
    [self.share setTitleColor:[UIColor colorFromHexString:@"7b7b7b"] titleFont:PingFangSCMedium11 imageName:@"group_share" backColor:[UIColor whiteColor] title:@"分享"];
    [self.save setTitleColor:[UIColor colorFromHexString:@"7b7b7b"] titleFont:PingFangSCMedium11 imageName:@"shoucang" backColor:[UIColor whiteColor] title:@"收藏"];
    [self.reportBtn setTitleColor:[UIColor colorFromHexString:@"7b7b7b"] titleFont:PingFangSCMedium11 imageName:@"dianzan" backColor:[UIColor whiteColor] title:@"点赞"];
    if (respone.data.praiseState.integerValue == 1) {
        self.reportBtn.imageName = @"dianzan2";
        self.reportBtn.titleString = @"已点赞";
    }else{
        self.reportBtn.imageName = @"dianzan";
        self.reportBtn.titleString = @"点赞";
    }
    if (respone.data.collectionState.integerValue == 1) {
        self.save.titleString = @"已收藏";
        self.save.imageName = @"shoucang2";
    }else{
         self.save.titleString = @"收藏";
        self.save.imageName = @"shoucang";
    }
}


@end
