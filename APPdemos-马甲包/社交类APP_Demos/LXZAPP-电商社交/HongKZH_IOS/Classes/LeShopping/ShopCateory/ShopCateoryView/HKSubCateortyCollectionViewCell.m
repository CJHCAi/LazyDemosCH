//
//  HKSubCateortyCollectionViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSubCateortyCollectionViewCell.h"
#import "ZSUserHeadBtn.h"
#import "UIButton+ZSYYWebImage.h"
@interface HKSubCateortyCollectionViewCell()
@property (weak, nonatomic) IBOutlet ZSUserHeadBtn *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation HKSubCateortyCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(SubCategorysCategorys *)model{
    _model = model;
    [self.headBtn hk_setBackgroundImageWithURL:model.imgSrc forState:0 placeholder:kPlaceholderImage];
    self.nameLabel.text  = model.name;
}
@end
