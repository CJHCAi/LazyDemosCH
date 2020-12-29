//
//  HKSubCategoryHeadCollectionViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSubCategoryHeadCollectionViewCell.h"
#import "HKSubCategoryListRespone.h"
@interface HKSubCategoryHeadCollectionViewCell()
@property (weak, nonatomic) IBOutlet SDCycleScrollView *imageScrView;
@property (weak, nonatomic) IBOutlet UILabel *titleView;

@end

@implementation HKSubCategoryHeadCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setRespone:(HKSubCategoryListRespone *)respone{
    _respone = respone;
    self.titleView.text = respone.data.name;
    self.imageScrView.imageURLStringsGroup = @[respone.data.imgSrc];
}
@end
