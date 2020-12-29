//
//  HKSeleMediaCollectionViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/15.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSeleMediaCollectionViewCell.h"
#import "UIImageView+HKWeb.h"
#import "UIButton+ZSYYWebImage.h"
#import "ZSUserHeadBtn.h"
@interface HKSeleMediaCollectionViewCell()
@property (weak, nonatomic) IBOutlet UILabel *znum;
@property (weak, nonatomic) IBOutlet UILabel *leNum;
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet ZSUserHeadBtn *headView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIImageView *zanIcon;
@property (weak, nonatomic) IBOutlet UIImageView *leBIcon;
@property (weak, nonatomic) IBOutlet UIImageView *areaIcon;
@property (weak, nonatomic) IBOutlet UILabel *rightlabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconR;
@property (weak, nonatomic) IBOutlet UIView *yjView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *right;
@property (weak, nonatomic) IBOutlet UIView *advertisement;
@property (weak, nonatomic) IBOutlet UIView *backView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTop;

@end

@implementation HKSeleMediaCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backView.layer.cornerRadius = 5;
    self.backView.layer.masksToBounds = YES;
    self.iconView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconView.clipsToBounds  = YES;
    // Initialization code
}
-(void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;

    if (self.headH>0&&(indexPath.item == 1||indexPath.item == 0)) {
        self.viewTop.constant = 10+self.headH;
    }else{
        self.viewTop.constant = 10;
    }
}
-(void)setModel:(SelfMediaModelList *)model{
    _model = model;
    self.znum.hidden = NO;
    self.zanIcon.hidden = NO;
   
    self.areaIcon.hidden = NO;
    self.areaLabel.hidden = NO;
    self.rightlabel.text = @"";
    if (model.totalMoney>0) {
         self.leBIcon.hidden = NO;
    }else{
         self.leBIcon.hidden = YES;
    }
    if (model.type == 2) {
        self.advertisement.hidden = NO;
        self.leBIcon.hidden = YES;
        self.zanIcon.hidden = YES;
        self.znum.hidden = YES;
    }else{
        self.advertisement.hidden = YES;
        self.zanIcon.hidden = NO;
        self.znum.hidden = NO;
    }
    self.znum.text = model.praiseCount.length>0?model.praiseCount:@"0";
    self.leNum.text = model.rewardCount;
    self.nameLabel.text = model.uName;
    if (model.cityName.length>0) {
        self.areaIcon.hidden = NO;
        self.areaLabel.hidden = NO;
        self.areaLabel.text = model.cityName;
    }else{
        self.areaIcon.hidden = YES;
        self.areaLabel.hidden = YES;
    }
    
    self.titleView.text = model.title;
   
    [self.iconView hk_sd_setImageWithURL:model.coverImgSrc placeholderImage:kPlaceholderImage];
    [self.headView hk_setBackgroundImageWithURL:model.headImg forState:0 placeholder:kPlaceholderHeadImage];
}

-(void)setCityM:(CityHomeModel *)cityM{
    _cityM = cityM;
    self.znum.hidden = NO;
    self.zanIcon.hidden = NO;
    
    self.areaIcon.hidden = NO;
    self.areaLabel.hidden = NO;
    self.rightlabel.text = @"";
    if (cityM.totalMoney>0) {
        self.leBIcon.hidden = NO;
    }else{
        self.leBIcon.hidden = YES;
    }
        self.advertisement.hidden = YES;
        self.zanIcon.hidden = NO;
        self.znum.hidden = NO;
    self.znum.text = cityM.praiseCount.length>0?cityM.praiseCount:@"0";
    self.leNum.text = cityM.rewardCount;
    self.nameLabel.text = cityM.name;
    if (cityM.cityName.length>0) {
        self.areaIcon.hidden = NO;
        self.areaLabel.hidden = NO;
        self.areaLabel.text = cityM.cityName;
    }else{
        self.areaIcon.hidden = YES;
        self.areaLabel.hidden = YES;
    }
    
    self.titleView.text = cityM.title;
    
    [self.iconView hk_sd_setImageWithURL:cityM.coverImgSrc placeholderImage:kPlaceholderImage];
    [self.headView hk_setBackgroundImageWithURL:cityM.headImg forState:0 placeholder:kPlaceholderHeadImage];
}

-(void)setCirclesListModel:(CategoryCirclesListModel *)circlesListModel{
    _circlesListModel = circlesListModel;
    self.znum.hidden = YES;
    self.zanIcon.hidden = YES;
    self.leBIcon.hidden = YES;
    self.areaIcon.hidden = YES;
    self.areaLabel.hidden = YES;
    self.rightlabel.text = @"人";
    self.advertisement.hidden = YES;
    self.leNum.text = circlesListModel.userCount;
    self.titleView.text = circlesListModel.name;
    [self.headView hk_setBackgroundImageWithURL:circlesListModel.headImg forState:0 placeholder:kPlaceholderHeadImage];
    [self.iconView hk_sd_setImageWithURL:circlesListModel.coverImgSrc placeholderImage:kPlaceholderImage];
    self.nameLabel.text = circlesListModel.uName;
}
@end
