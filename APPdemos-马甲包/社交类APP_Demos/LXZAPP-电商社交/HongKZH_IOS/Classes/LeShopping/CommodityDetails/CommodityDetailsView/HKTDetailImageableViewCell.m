//
//  HKTDetailImageableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKTDetailImageableViewCell.h"
#import "CommodityDetailsRespone.h"
#import "SDCycleScrollView.h"
@interface HKTDetailImageableViewCell()<SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *numBackView;
@property (weak, nonatomic) IBOutlet SDCycleScrollView *iconsView;
@property (weak, nonatomic) IBOutlet UILabel *orderNum;

@end

@implementation HKTDetailImageableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.numBackView.layer.cornerRadius = 11;
    self.numBackView.layer.masksToBounds = YES;
    self.iconsView.showPageControl = NO;
    self.iconsView.delegate = self;
    self.numBackView.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.3];
}
-(void)setImageArray:(NSArray *)imageArray{
    _imageArray = imageArray;
    NSMutableArray*array = [NSMutableArray arrayWithCapacity:imageArray.count];
    for (CommodityDetailsesImages*model in imageArray) {
        [array addObject:model.imgSrc];
    }
    self.orderNum.text = [NSString stringWithFormat:@"1/%ld",imageArray.count];
    self.iconsView.imageURLStringsGroup = array.copy;
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    self.orderNum.text = [NSString stringWithFormat:@"%ld/%ld",index+1,self.imageArray.count];
}
@end
