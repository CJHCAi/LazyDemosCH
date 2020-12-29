//
//  HKRecommendType1TableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/13.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKRecommendType1TableViewCell.h"
#import "ZSUserHeadBtn.h"
#import "UIButton+ZSYYWebImage.h"
#import "UIImageView+HKWeb.h"
#import "HKSlider.h"
@interface HKRecommendType1TableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet ZSUserHeadBtn *headView;
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UIImageView *typeIcon;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet HKSlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *redNum;

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *rtimeLabel;
@property (weak, nonatomic) IBOutlet UIView *timeBack;
@property (weak, nonatomic) IBOutlet UILabel *showLabelss;
@property (weak, nonatomic) IBOutlet UIView *imagecontecnView;

@end

@implementation HKRecommendType1TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code·
    self.backView.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.6];
//    self.backView.layer.cornerRadius = 5;
//    self.backView.layer.masksToBounds =YES;
//    self.iconView.layer.cornerRadius  =4;
//    self.iconView.layer.masksToBounds =YES;
//    self.iconView.layer.borderColor =[[UIColor colorFromHexString:@"cccccc"] CGColor];
//    self.iconView.layer.borderWidth =1;
    self.timeBack.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.6];
    self.timeBack.layer.cornerRadius = 3;
    self.backVIews.layer.cornerRadius = 10;
    self.backVIews.layer.masksToBounds = YES;
    self.shareView.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.6];
    UIImage *thumbImage = [UIImage imageNamed:@"lb_01"];
    [self.slider setThumbImage:thumbImage forState:UIControlStateNormal];
    self.imagecontecnView.layer.cornerRadius = 5;
    self.imagecontecnView.layer.masksToBounds = YES;
}
-(void)setModel:(RecommendModel *)model{
    _model = model;
    self.timeLabel.text = model.vedioLength;
    self.rtimeLabel.text = model.vedioLength;
   
    self.redNum.text = [NSString stringWithFormat:@"%ld",model.lastIntegralCount];
    [self.iconView hk_sd_setImageWithURL:model.coverImgSrc placeholderImage:kPlaceholderHeadImage];
    [self.headView hk_setBackgroundImageWithURL:model.headImg forState:0 placeholder:kPlaceholderImage];
    self.nameLabel.text = model.title;
    self.titleView.text = [NSString stringWithFormat:@"%@·%@·%@人观看",model.name,model.categoryName,model.playCount];
    if (model.type == HKSowingModelType_SelfMediaM) {
        self.typeIcon.image = [UIImage imageNamed:@"list_selfM"];
    }else if (model.type == HKSowingModelType_Advertising){
        self.typeIcon.image = [UIImage imageNamed:@"look_comend_advert"];
    }else if (model.type == HKSowingModelType_CityAdvertising){
        self.typeIcon.image = [UIImage imageNamed:@"look_city_advert"];
    }else{
        self.typeIcon.image = [UIImage imageNamed:@"look_culture_advert"];
    }
}
-(void)setHotModel:(PriseHotAdvListModel *)hotModel{
    _hotModel = hotModel;
    self.timeLabel.text = hotModel.vedioLength;
    
    self.rtimeLabel.text = hotModel.vedioLength;
    [self.iconView hk_sd_setImageWithURL:hotModel.coverImgSrc placeholderImage:kPlaceholderHeadImage];
    [self.headView hk_setBackgroundImageWithURL:hotModel.headImg forState:0 placeholder:kPlaceholderImage];
    self.nameLabel.text = hotModel.title;
    self.titleView.text = [NSString stringWithFormat:@"%@·%ld人观看",hotModel.uName,hotModel.playCount];
    if (hotModel.costCount == 0) {
        self.showLabelss.text = @"已抢完";
        self.redNum.hidden = YES;
        self.slider.value = 1;
    }else{
        self.showLabelss.text = @"余";
        self.redNum.hidden = NO;
        self.redNum.text = [NSString stringWithFormat:@"%ld",(long)hotModel.costCount];
        self.slider.value = (hotModel.integralCount)/hotModel.costCount;
    }
    
}
@end
