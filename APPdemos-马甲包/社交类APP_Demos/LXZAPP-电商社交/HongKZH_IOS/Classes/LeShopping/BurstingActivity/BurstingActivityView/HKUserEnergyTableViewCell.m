//
//  HKUserEnergyTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKUserEnergyTableViewCell.h"
#import "HKluckyBurstDetailRespone.h"
#import "ZSUserHeadBtn.h"
#import "UIButton+ZSYYWebImage.h"
#import "UIImage+YY.h"
@interface HKUserEnergyTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet ZSUserHeadBtn *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *energy;
@property (weak, nonatomic) IBOutlet UILabel *orderNum;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ProportionW;
@property (weak, nonatomic) IBOutlet UIImageView *totalNum;
@property (weak, nonatomic) IBOutlet UIImageView *backIcon;
@property (weak, nonatomic) IBOutlet UIImageView *descIcon;
@property (weak, nonatomic) IBOutlet UIView *arrow;
@property (weak, nonatomic) IBOutlet UIImageView *numIcon;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation HKUserEnergyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0];
    self.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0];
    self.backIcon.image = [[UIImage createImageWithColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.8] size:CGSizeMake(kScreenWidth-30, 220)]zsyy_imageByRoundCornerRadius:5];
    self.totalNum.image = [[UIImage createImageWithColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.8] size:CGSizeMake(kScreenWidth-30-50-40, 20)]zsyy_imageByRoundCornerRadius:10];
    self.arrow.layer.cornerRadius = 6;
    self.arrow.layer.masksToBounds = YES;
}
-(void)setRespone:(HKluckyBurstDetailRespone *)respone{
    _respone = respone;
    self.nameL.text = respone.data.u.name;
    [self.headBtn hk_setBackgroundImageWithURL:respone.data.u.headImg forState:0 placeholder:kPlaceholderHeadImage];
    self.energy.text = [NSString stringWithFormat:@"%@",respone.data.u.num];
    self.orderNum.text = [NSString stringWithFormat:@"%@",respone.data.u.ranking];
    if (respone.data.totalNum == 0) {
        self.ProportionW.constant =0;
    }else{
    self.ProportionW.constant = self.totalNum.width*respone.data.u.num.integerValue/respone.data.totalNum-6;
    }
    self.descIcon.image =  [[UIImage createImageWithColor:[UIColor colorWithRed:222.0/255.0 green:194.0/255.0 blue:243.0/255.0 alpha:1] size:CGSizeMake(self.descIcon.width, 27)]zsyy_imageByRoundCornerRadius:13.5];
}
- (IBAction)shareFriendEnergy:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(friendsHelp)]) {
        [self.delegate friendsHelp];
    }
}
- (IBAction)friendHlep:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(helpFriends)]) {
        [self.delegate helpFriends];
    }
}
- (IBAction)seeHelpFriend:(id)sender {
    if ([self.delegate respondsToSelector:@selector(gotoHelpFriendList)]) {
        [self.delegate gotoHelpFriendList];
    }
}

@end
