//
//  HKToolTranslateViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKToolTranslateViewCell.h"
#import "UIImageView+HKWeb.h"
@interface HKToolTranslateViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end

@implementation HKToolTranslateViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(GetMediaAdvAdvByIdProducts *)model{
    _model = model;
    [self.iconView hk_sd_setImageWithURL:model.imgSrc placeholderImage:kPlaceholderImage];
}
@end
