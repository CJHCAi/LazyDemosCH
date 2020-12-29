//
//  HKSearchCliFootView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/24.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSearchCliFootView.h"

@implementation HKSearchCliFootView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"HKSearchCliFootView" owner:self options:nil].lastObject;
    }
    return self;
}
- (IBAction)footerClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(footerClick)]) {
        [self.delegate footerClick];
    }
}

@end
