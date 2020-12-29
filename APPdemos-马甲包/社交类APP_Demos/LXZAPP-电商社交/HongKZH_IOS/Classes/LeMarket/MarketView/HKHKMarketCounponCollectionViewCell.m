//
//  HKHKMarketCounponCollectionViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/19.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKHKMarketCounponCollectionViewCell.h"
#import "UIImageView+HKWeb.h"
@interface HKHKMarketCounponCollectionViewCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconViewe;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *emptyICon;
@property (weak, nonatomic) IBOutlet UIImageView *backIcon;

@end

@implementation HKHKMarketCounponCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(HKCounList *)model{
    _model = model;
    if (model) {
        self.emptyICon.hidden = YES;
        self.iconViewe.hidden = NO;
        self.nameLabel.hidden = NO;
        self.dateLabel.hidden = NO;
        self.backIcon.hidden = NO;
        [self.iconViewe hk_sd_setImageWithURL:model.imgSrc placeholderImage:kPlaceholderImage];
        self.nameLabel.text = model.title;
        self.dateLabel.text = [NSString stringWithFormat:@"%@-%@",model.beginTime,model.endTime];
    }else{
        self.iconViewe.hidden = YES;
        self.nameLabel.hidden = YES;
        self.dateLabel.hidden = YES;
        self.emptyICon.hidden = NO;
        self.backIcon.hidden = YES;
    }
 

}
@end
