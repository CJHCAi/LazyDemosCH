//
//  HKSelfMeidaVodeoNavView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/13.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSelfMeidaVodeoNavView.h"
#import "ZSUserHeadBtn.h"
#import "GetMediaAdvAdvByIdRespone.h"
#import "UIButton+ZSYYWebImage.h"
@interface HKSelfMeidaVodeoNavView()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet ZSUserHeadBtn *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *num;

@property (weak, nonatomic) IBOutlet UILabel *zL;
@property (weak, nonatomic) IBOutlet UIImageView *leBIcon;

@property (weak, nonatomic) IBOutlet UIImageView *lebBackIcon;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;

@end

@implementation HKSelfMeidaVodeoNavView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"HKSelfMeidaVodeoNavView" owner:self options:nil].lastObject;
        self.lebBackIcon.layer.cornerRadius = 12;
        self.lebBackIcon.layer.masksToBounds = YES;
        self.lebBackIcon.image = [UIImage imageWithColor:[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.3]];
        if ([[VersionAuditStaueTool sharedVersionAuditStaueTool]isAuditAdopt]) {
            self.leBIcon.hidden = NO;
            self.lebBackIcon.hidden = NO;
            self.zL.hidden = NO;
        }else{
            self.leBIcon.hidden = YES;
            self.lebBackIcon.hidden = YES;
            self.zL.hidden = YES;
        }
    }
    return self;
}
- (IBAction)back:(id)sender {
    if ([self.delegate respondsToSelector:@selector(backVc)]) {
        [self.delegate backVc];
    }
}
 - (IBAction)topCick:(UIButton *)sender {
     if (self.delegate &&[self.delegate respondsToSelector:@selector(headMoreSender:withResponse:)]) {
         [self.delegate headMoreSender:sender.tag withResponse:self.respone];
     }
}
-(void)setRespone:(GetMediaAdvAdvByIdRespone *)respone{
    _respone = respone;
    self.name.text = respone.data.uName;
    self.descLabel.text = [NSString stringWithFormat:@"%@⋅%@次播放",respone.data.categoryName,respone.data.playCount];
    self.num.text = respone.data.rewardCount;
    [self.headBtn hk_setBackgroundImageWithURL:respone.data.headImg forState:0 placeholder:kPlaceholderImage];
    if ([[VersionAuditStaueTool sharedVersionAuditStaueTool]isAuditAdopt]) {
        if (respone.data.rewardCount.length>0) {
            self.zL.hidden = NO;
            self.lebBackIcon.hidden = NO;
            self.leBIcon.hidden = NO;
            self.num.hidden = NO;
        }else{
            self.zL.hidden = NO;
            self.lebBackIcon.hidden = NO;
            self.leBIcon.hidden = NO;
            self.num.hidden = NO;
        }

    }
    if ([LoginUserData sharedInstance].chatId.integerValue ==respone.data.uid.integerValue) {
        self.moreBtn.hidden = YES;
    }else {
        self.moreBtn.hidden = NO;
    }
}
-(void)setTime:(NSInteger)time{
    _time = time;
    self.num.text = [NSString stringWithFormat:@"%ld",time];
}
@end
