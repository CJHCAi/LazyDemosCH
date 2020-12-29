//
//  HKHostItemView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKHostItemView.h"
#import "UIImageView+HKWeb.h"
#import "UIImage+YY.h"
@interface HKHostItemView()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;

@end

@implementation HKHostItemView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"HKHostItemView" owner:self options:nil].lastObject;
        self.iconView.layer.cornerRadius = 3;
        self.iconView.layer.masksToBounds = YES;
        UIImage*image = [UIImage createImageWithColor:[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.6] size:CGSizeMake(36, 18)];
        image = [image zsyy_imageByRoundCornerRadius:2];
        [self.timeBtn setBackgroundImage:image forState:0];
    }
    return self;
}
-(void)setModel:(HKHotModel *)model{
    _model = model;
    [self.iconView hk_sd_setImageWithURL:model.coverImgSrc placeholderImage:kPlaceholderImage];
    self.nameLabel.text = model.title;
    self.titleView.text = [NSString stringWithFormat:@"%@·%@·%@人观看",model.uName,model.categoryName,model.playCount];
    [self.timeBtn setTitle:model.vedioLength forState:0];
}
- (IBAction)c:(id)sender {
    if ([self.delegate respondsToSelector:@selector(itemClick:)]) {
        [self.delegate itemClick:self.tag];
    }
}
@end
