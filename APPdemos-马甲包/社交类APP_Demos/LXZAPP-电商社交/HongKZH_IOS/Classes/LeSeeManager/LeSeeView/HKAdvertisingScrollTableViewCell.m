//
//  HKAdvertisingScrollTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/13.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKAdvertisingScrollTableViewCell.h"
#import "HKSowingRespone.h"
#import "HKSowingModel.h"
@interface HKAdvertisingScrollTableViewCell()
@property (weak, nonatomic) IBOutlet SDCycleScrollView *scrollView;

@end

@implementation HKAdvertisingScrollTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.scrollView.autoScroll = YES;
    self.scrollView.backgroundColor =[UIColor redColor];
    self.scrollView.scrollDirection =UICollectionViewScrollDirectionVertical;
    self.scrollView.autoScrollTimeInterval =3;
    self.scrollView.bannerImageViewContentMode =UIViewContentModeScaleAspectFill;
    self.scrollView.showPageControl = NO;
    // Initialization code
}
-(void)setSowIng:(HKSowingRespone *)sowIng{
    _sowIng = sowIng;
    NSMutableArray*array = [NSMutableArray arrayWithCapacity:sowIng.data.count];
    for (HKSowingModel*model in sowIng.data) {
        [array addObject:model.imgSrc];
    }
    self.scrollView.imageURLStringsGroup = array;
}
@end
