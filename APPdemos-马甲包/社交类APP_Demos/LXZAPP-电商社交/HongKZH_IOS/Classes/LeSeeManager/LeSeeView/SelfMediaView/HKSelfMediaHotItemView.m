//
//  HKSelfMediaHotItemView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/15.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSelfMediaHotItemView.h"
#import "UIImageView+HKWeb.h"
#import "ZSUserHeadBtn.h"
#import "UIButton+ZSYYWebImage.h"
@interface HKSelfMediaHotItemView()
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIImageView *topNum;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet ZSUserHeadBtn *userHead;
@property (weak, nonatomic) IBOutlet UILabel *zNUn;
@property (weak, nonatomic) IBOutlet UILabel *careLabel;
@property (weak, nonatomic) IBOutlet UIImageView *redBoxIcon;

@end

@implementation HKSelfMediaHotItemView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"HKSelfMediaHotItemView" owner:self options:nil].lastObject;
        self.iconView.layer.cornerRadius = 5;
        self.iconView.layer.masksToBounds = YES;
        self.redBoxIcon.image = nil;
        self.iconView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return self;
}
-(void)setModel:(CategoryTop10ListModel *)model{
    _model = model;
    self.zNUn.text = model.praiseCount;
    self.titleView.text = model.title;
    [self.iconView hk_sd_setImageWithURL:model.coverImgSrc placeholderImage:kPlaceholderImage];
    [self.userHead hk_setBackgroundImageWithURL:model.headImg forState:0 placeholder:kPlaceholderHeadImage];
    self.name.text = model.uName;
    self.careLabel.text = model.categoryName;
}

-(void)setTag:(NSInteger)tag{
    [super setTag:tag];
    if (tag == 0) {
        self.topNum.image = [UIImage imageNamed:@"selfMedia_top1"];
    }else if (tag == 1){
        self.topNum.image = [UIImage imageNamed:@"selfMedia_top2"];
    }else if (tag == 2){
         self.topNum.image = [UIImage imageNamed:@"selfMedia_top3"];
    }else{
         self.topNum.image = [UIImage imageNamed:@""];
    }
}
@end
