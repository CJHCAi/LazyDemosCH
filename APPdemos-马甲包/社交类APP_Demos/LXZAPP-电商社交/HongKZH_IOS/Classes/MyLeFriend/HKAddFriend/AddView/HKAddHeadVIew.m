//
//  HKAddHeadVIew.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKAddHeadVIew.h"

@implementation HKAddHeadVIew

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"HKAddHeadVIew" owner:self options:nil].lastObject;
    }
    return self;
}
- (IBAction)gotoAddress:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(gotoAddress)]) {
        [self.delegate gotoAddress];
    }
}

@end
