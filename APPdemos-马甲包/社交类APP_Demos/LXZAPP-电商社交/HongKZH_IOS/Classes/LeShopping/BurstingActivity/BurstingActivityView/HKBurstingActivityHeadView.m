//
//  HKBurstingActivityHeadView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBurstingActivityHeadView.h"
#import "HKLuckyBurstRespone.h"
#import "HKBurstingActivityTypeItem.h"
@interface HKBurstingActivityHeadView()<HKBurstingActivityTypeItemDelegate>
@property (weak, nonatomic) IBOutlet SDCycleScrollView *sowingMap;
@property (weak, nonatomic) IBOutlet UIView *typeView;
@property (nonatomic, strong)UIScrollView *scrollView;
@end

@implementation HKBurstingActivityHeadView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self = [[NSBundle mainBundle]loadNibNamed:@"HKBurstingActivityHeadView" owner:self options:nil].lastObject;
    if (self) {
        self.frame = frame;
        [self.typeView addSubview:self.scrollView];
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.typeView);
        }];
    }
    return self;
}
-(void)setRespone:(HKLuckyBurstRespone *)respone{
    _respone = respone;
    NSMutableArray*array = [NSMutableArray arrayWithCapacity:respone.data.carousels.count];
    for (LuckyBurstCarousels*model in respone.data.carousels) {
        [array addObject:model.imgSrc];
    }
    self.sowingMap.imageURLStringsGroup = array;
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIImage *image = [UIImage imageNamed:@"bkms_qgz"];
    CGFloat w = image.size.width+20;
    for (int i = 0; i<respone.data.types.count; i++) {
        HKBurstingActivityTypeItem*itme = [[HKBurstingActivityTypeItem alloc]initWithFrame:CGRectMake(i*w, 0, w, 60)];
        itme.tag = i;
        [self.scrollView addSubview:itme];
        itme.delegate = self;
        itme.model = respone.data.types[i];
    }
}
-(void)btnClick:(NSInteger)tag{
    if ([self.delegate respondsToSelector:@selector(switchVc:)]) {
        [self.delegate switchVc:tag];
    }
}
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        _scrollView = scrollView;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.bounces = NO;
    }
    return _scrollView;
}
@end
