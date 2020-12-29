//
//  HKRecruitHeadView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/14.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKRecruitHeadView.h"
#import "HKImageAndTitleBtn.h"
#import "HKSowingRespone.h"
#import "HKSowingModel.h"
@interface HKRecruitHeadView()
@property (weak, nonatomic) IBOutlet SDCycleScrollView *scrollVIew;
@property (weak, nonatomic) IBOutlet HKImageAndTitleBtn *searchBtn;
@property (weak, nonatomic) IBOutlet UIButton *recommend;
@property (weak, nonatomic) IBOutlet UIButton *clicle;

@end

@implementation HKRecruitHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"HKRecruitHeadView" owner:self options:nil].lastObject;
        [self.searchBtn setBackColor:[UIColor colorWithRed:0.0/255.0 green:146.0/255.0 blue:255.0/255.0 alpha:1] icon:@"search" title:@"搜索职位"];
        self.frame = frame;
    }
    return self;
}
-(void)setModel:(HKSowingRespone *)model{
    _model = model;
    NSMutableArray*imageArray = [NSMutableArray arrayWithCapacity:model.data.count];
    for (HKSowingModel*imageM in model.data) {
        [imageArray addObject:imageM.imgSrc];
    }
    self.scrollVIew.imageURLStringsGroup = imageArray;
}
- (IBAction)btnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(switchVc:)]) {
        [self.delegate switchVc:sender.tag];
    }
}
@end
