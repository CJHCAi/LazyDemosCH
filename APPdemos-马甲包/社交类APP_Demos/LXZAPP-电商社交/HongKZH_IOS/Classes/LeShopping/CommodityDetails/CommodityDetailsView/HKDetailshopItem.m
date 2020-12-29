//
//  HKDetailshopItem.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKDetailshopItem.h"
#import "UIImageView+HKWeb.h"
@interface HKDetailshopItem()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *num;

@end

@implementation HKDetailshopItem

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(CommodityDetailsesRecs *)model{
    _model = model;
    [self.iconView hk_sd_setImageWithURL:model.imgSrc placeholderImage:kPlaceholderImage];
    self.titleView.text = model.title;
    self.num.text = [NSString stringWithFormat:@"¥%.2f",model.integral];
}
@end
