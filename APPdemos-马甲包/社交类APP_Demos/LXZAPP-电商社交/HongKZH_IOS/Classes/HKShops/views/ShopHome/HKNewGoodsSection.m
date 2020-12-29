//
//  HKNewGoodsSection.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKNewGoodsSection.h"

@implementation HKNewGoodsSection

-(instancetype)initWithFrame:(CGRect)frame {
    if (self =[super initWithFrame:frame]) {
        self.backgroundColor = MainColor
        [self addSubview:self.timeLabel];
    }
    return self;
}
-(UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel =[[UILabel alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,40)];
        [AppUtils getConfigueLabel:_timeLabel font:PingFangSCRegular12 aliment:NSTextAlignmentCenter textcolor:RGB(153,153, 153) text:@"9月12日本店上新"];
    }
    return _timeLabel;
}

@end
