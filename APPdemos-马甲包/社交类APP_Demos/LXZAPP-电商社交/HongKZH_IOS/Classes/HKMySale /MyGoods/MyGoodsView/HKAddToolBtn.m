//
//  HKAddToolBtn.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/17.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKAddToolBtn.h"

@implementation HKAddToolBtn

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"HKAddToolBtn" owner:self options:nil].lastObject;
    }
    return self;
}
- (IBAction)addClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(addClick)]) {
        [self.delegate addClick];
    }
}

@end
