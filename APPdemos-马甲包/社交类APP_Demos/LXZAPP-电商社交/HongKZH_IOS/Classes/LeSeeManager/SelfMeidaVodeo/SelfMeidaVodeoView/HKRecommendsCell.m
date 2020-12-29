//
//  HKRecommendsCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/21.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKRecommendsCell.h"
#import "UIImageView+HKWeb.h"
@interface HKRecommendsCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *num;
@property (weak, nonatomic) IBOutlet UIImageView *red_bot;
@property (weak, nonatomic) IBOutlet UILabel *red_label;

@end

@implementation HKRecommendsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.red_bot.hidden = YES;
    self.red_label.hidden = YES;
    self.iconView.layer.cornerRadius = 5;
    self.iconView.layer.masksToBounds = YES;
    self.timeLabel.layer.cornerRadius = 7;
    self.timeLabel.layer.masksToBounds = YES;
    
}
-(void)setModel:(RecommendModle *)model{
    _model = model;
    self.timeLabel.text = model.vedioLength.length>0?model.vedioLength:@"";
    if (model.vedioLength.length>0) {
        self.timeLabel.hidden = NO;
    }else{
        self.timeLabel.hidden = YES;
    }
    self.titleView.text = model.title.length>0?model.title:@"";
    self.num.text = [NSString stringWithFormat:@"%@⋅%@观看",model.name.length>0?model.name:@"",model.playCount.length>0?model.playCount:@"0"];
    [self.iconView hk_sd_setImageWithURL:model.coverImgSrc placeholderImage:kPlaceholderImage];
}
-(void)setIsPublish:(BOOL)isPublish {
   // red_img
    self.red_label.hidden = NO;
    self.red_bot.hidden =NO;
}
-(void)setList:(HKCompanyPublishList *)list {
    _list = list;
    self.timeLabel.text =list.vedioLength.length>0 ?list.vedioLength :@"";
    self.titleView.text =list.title;
    self.num.text = [NSString stringWithFormat:@"%@发布⋅%@观看",list.createDate,list.playCount];
    [self.iconView hk_sd_setImageWithURL:list.coverImgSrc placeholderImage:kPlaceholderImage];

}

@end
