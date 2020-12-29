//
//  HKSowIngView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSowIngView.h"
#import "UIImageView+HKWeb.h"
#import "HKSowingModel.h"
@interface HKSowIngView()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIImageView *typeImage;
@property (weak, nonatomic) IBOutlet UILabel *titleView;

@end

@implementation HKSowIngView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"HKSowIngView" owner:self options:nil].lastObject;
    }
    return self;
}
-(void)setModel:(HKSowingModel *)model{
    _model = model;
    [self.iconView hk_sd_setImageWithURL:model.imgSrc placeholderImage:kPlaceholderImage];
    self.titleView.text = model.title;
    if (model.type == HKSowingModelType_SelfMediaM) {
        self.typeImage.image = [UIImage imageNamed:@"list_selfM"];
    }else if (model.type == HKSowingModelType_Advertising){
      self.typeImage.image = [UIImage imageNamed:@"look_comend_advert"];
    }else if (model.type == HKSowingModelType_CityAdvertising){
        self.typeImage.image = [UIImage imageNamed:@"look_city_advert"];
    }else{
            self.typeImage.image = [UIImage imageNamed:@"look_culture_advert"];
        }
    
}
@end
