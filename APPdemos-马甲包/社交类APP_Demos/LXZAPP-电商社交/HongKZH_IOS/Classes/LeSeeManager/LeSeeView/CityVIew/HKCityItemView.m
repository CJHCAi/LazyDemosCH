//
//  HKCityItemView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/14.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCityItemView.h"
#import "UIImageView+HKWeb.h"
@interface HKCityItemView()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end

@implementation HKCityItemView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"HKCityItemView" owner:self options:nil].lastObject;
        self.iconView.layer.cornerRadius = 5;
        self.iconView.layer.masksToBounds = YES;
    }
    return self;
}

-(void)setModel:(CityMainHostModel *)model{
    _model = model;
    [self.iconView hk_sd_setImageWithURL:model.imgSrc placeholderImage:kPlaceholderImage];
    self.nameLabel.text = model.cityName;
    self.descLabel.text = model.subtitle;
}
- (IBAction)itemClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickItem:)]) {
        
        
        [self.delegate clickItem:self.tag];
        
    }
}
@end
