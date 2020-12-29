//
//  HKHostPageView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKHostPageView.h"
#import "HKHostItemView.h"
@interface HKHostPageView()<HKHostItemViewDelegate>

@end

@implementation HKHostPageView
-(void)setArray:(NSMutableArray *)array{
    _array = array;
    for (int i = 0; i<array.count; i++) {
        HKHostItemView*itemV = [[HKHostItemView alloc]init];
        [self addSubview:itemV];
        itemV.tag = i;
        itemV.delegate = self;
        int row = i/2;
        int l = i%2;
        CGFloat w = (kScreenWidth - 30 - 5)*0.5;
        CGFloat h = w*97/170+39;
        [itemV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(l*(w+5));
            make.top.equalTo(self).offset(15+row*(15+h));
            make.width.mas_equalTo(w);
            make.height.mas_equalTo(h);
        }];
        itemV.model = array[i];
    }
}

-(void)itemClick:(NSInteger)tag{
    if ([self.delegate respondsToSelector:@selector(clickHot:)]) {
        [self.delegate clickHot:self.tag*4+tag];
    }
}
@end
