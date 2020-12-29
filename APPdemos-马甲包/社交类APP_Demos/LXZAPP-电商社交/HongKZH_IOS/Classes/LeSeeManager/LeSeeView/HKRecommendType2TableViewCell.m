//
//  HKRecommendType2TableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/13.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKRecommendType2TableViewCell.h"
#import "UIView+BorderLine.h"
#import "UIImageView+HKWeb.h"
@interface HKRecommendType2TableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *namelabel;
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *redNum;
@property (weak, nonatomic) IBOutlet UILabel *typename;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIView *backVIew;

@end

@implementation HKRecommendType2TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.lineView borderForColor:[UIColor colorFromHexString:@"cccccc"] borderWidth:1 borderType:UIBorderSideTypeAll];
//    self.lineView.layer.cornerRadius =4;
//    self.lineView.layer.masksToBounds =YES;
//    self.contentView.layer.cornerRadius =4;
//    self.contentView.layer.masksToBounds = YES;
//    self.contentView.layer.borderWidth =1;
//    self.contentView.layer.borderColor =[[UIColor colorFromHexString:@"cccccc"] CGColor];
    
}
-(void)setModel:(RecommendModel *)model{
    _model = model;
    [self.iconView hk_sd_setImageWithURL:model.coverImgSrc placeholderImage:kPlaceholderImage];
    self.namelabel.text = model.title;
    self.titleView.text = [NSString stringWithFormat:@"%@·%@·%@人观看",model.name,model.categoryName,model.playCount];
    self.redNum.text = [NSString stringWithFormat:@"%ld",model.lastIntegralCount];
    self.typename.text = model.categoryName;
}
-(void)setHotModel:(PriseHotAdvListModel *)hotModel{
    _hotModel = hotModel;
    [self.iconView hk_sd_setImageWithURL:hotModel.coverImgSrc placeholderImage:kPlaceholderImage];
    self.namelabel.text = hotModel.title;
    self.titleView.text = [NSString stringWithFormat:@"%@·%ld人观看",hotModel.uName,hotModel.playCount];
    self.redNum.text = [NSString stringWithFormat:@"%ld",hotModel.lastCount];
    self.typename.text = @"";
    
}
@end
