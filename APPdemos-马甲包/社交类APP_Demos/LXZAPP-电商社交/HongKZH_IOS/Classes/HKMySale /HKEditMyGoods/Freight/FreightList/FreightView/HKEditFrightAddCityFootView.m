//
//  HKEditFrightAddCityFootView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKEditFrightAddCityFootView.h"
@interface HKEditFrightAddCityFootView()

@end

@implementation HKEditFrightAddCityFootView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self = [[NSBundle mainBundle]loadNibNamed:@"HKEditFrightAddCityFootView" owner:self options:nil].lastObject;
    if (self) {
        self.frame = frame;
    }
    return self;
}
- (IBAction)btnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(addClick)]) {
        [self.delegate addClick];
    }
}

@end
