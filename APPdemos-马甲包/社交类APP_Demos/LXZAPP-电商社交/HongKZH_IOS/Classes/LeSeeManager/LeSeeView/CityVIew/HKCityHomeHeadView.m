//
//  HKCityHomeHeadView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/14.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCityHomeHeadView.h"
#import "HKCtyItemListView.h"
#import "UIImageView+HKWeb.h"
#import "SDCycleScrollView.h"
@interface HKCityHomeHeadView()<HKCtyItemListViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet HKCtyItemListView *listVIew;
@property (weak, nonatomic) IBOutlet SDCycleScrollView *headList;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn0;
@property (weak, nonatomic) IBOutlet UIImageView *cityView;



@end

@implementation HKCityHomeHeadView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"HKCityHomeHeadView" owner:self options:nil].lastObject;
        self.frame = frame;
        UITapGestureRecognizer * tapCity  =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCity)];
        self.cityView.userInteractionEnabled = YES;
        [self.cityView addGestureRecognizer:tapCity];
        [self.btn0 setTitleColor:RGB(40,153, 254) forState:UIControlStateNormal];
        [self.btn1 setTitleColor:[UIColor colorFromHexString:@"666666"] forState:UIControlStateNormal];
    
    }
    return self;
}

-(void)clickCity {
    if (self.delegate && [self.delegate respondsToSelector:@selector(gotoPubLish:)]) {
        [self.delegate gotoPubLish:@""];
    }
}

-(void)setRespone:(CityMainRespone *)respone{
    _respone = respone;
    NSMutableArray*imageArray = [NSMutableArray arrayWithCapacity:respone.data.carousels.count];
    for (CarouselsModel*model in respone.data.carousels) {
        [imageArray addObject:model.imgSrc];
    }
    self.headList.imageURLStringsGroup = imageArray;
    self.listVIew.dataArray = respone.data.hots;
    self.listVIew.delegate = self;
}

-(void)itemClick:(NSInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(gotoVcLocaWithIsLoc:)]) {
        [self.delegate gotoVcLocaWithIsLoc:(int)index];
    }
}
- (IBAction)gotoCity:(id)sender {
    if ([self.delegate respondsToSelector:@selector(toVcCity)]) {
        [self.delegate toVcCity];
    }
}
- (IBAction)gotoLoca:(id)sender {
    if ([self.delegate respondsToSelector:@selector(gotoVcLocaWithIsLoc:)]) {
        [self.delegate gotoVcLocaWithIsLoc:-1];
    }
}
- (IBAction)switchType:(UIButton *)sender {
    if (sender.tag==10) {
        [self.btn0 setTitleColor:RGB(40,153, 254) forState:UIControlStateNormal];
        [self.btn1 setTitleColor:[UIColor colorFromHexString:@"666666"] forState:UIControlStateNormal];
    }else {
        [self.btn1 setTitleColor:RGB(40,153, 254) forState:UIControlStateNormal];
        [self.btn0 setTitleColor:[UIColor colorFromHexString:@"666666"] forState:UIControlStateNormal];
    }
    if ([self.delegate respondsToSelector:@selector(gotoSwitchType:)]) {
       
        [self.delegate gotoSwitchType:sender.tag];
        
        
    }
}
@end
