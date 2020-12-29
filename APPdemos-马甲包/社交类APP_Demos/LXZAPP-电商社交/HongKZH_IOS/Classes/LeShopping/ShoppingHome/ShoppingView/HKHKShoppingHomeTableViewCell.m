//
//  HKHKShoppingHomeTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/18.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKHKShoppingHomeTableViewCell.h"
#import "HKLeShopHomeRespone.h"
@interface HKHKShoppingHomeTableViewCell()
@property (weak, nonatomic) IBOutlet SDCycleScrollView *scrollView;

@end

@implementation HKHKShoppingHomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)setImageArray:(NSMutableArray *)imageArray{
    _imageArray = imageArray;
    NSMutableArray*array = [NSMutableArray arrayWithCapacity:imageArray.count];
    for (HKLeShopHomeCarouseles*model in imageArray) {
        [array addObject:model.imgSrc];
    }
    self.scrollView.imageURLStringsGroup = array;
}
@end
