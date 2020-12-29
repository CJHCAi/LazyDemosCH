//
//  HKMarketGoodsCollectionViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/19.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMarketGoodsCollectionViewCell.h"
#import "UIImageView+HKWeb.h"
@interface HKMarketGoodsCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIView *content;
@property (weak, nonatomic) IBOutlet UIImageView *empty;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageW;
@property (weak, nonatomic) IBOutlet UILabel *title;

@end

@implementation HKMarketGoodsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  
    // Initialization code
}
-(void)setModel:(HKGameProductModel *)model{
    _model = model;
    if (model) {
        self.content.hidden = NO;
        self.empty.hidden = YES;
        [self.iconView hk_sd_setImageWithURL:model.imgSrc placeholderImage:kPlaceholderImage];
        self.title.text = model.title;
        self.price.text = [NSString stringWithFormat:@"¥%ld",model.price];
    }else{
        self.content.hidden = YES;
        self.empty.hidden = NO;
    }
   
}
@end
