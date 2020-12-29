//
//  HKGoodsListFootView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/24.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKGoodsListFootView.h"

@implementation HKGoodsListFootView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self = [[NSBundle mainBundle]loadNibNamed:@"HKGoodsListFootView" owner:self options:nil].lastObject;
    if (self) {
        self.frame = frame;
    }
    return self;
}

@end
