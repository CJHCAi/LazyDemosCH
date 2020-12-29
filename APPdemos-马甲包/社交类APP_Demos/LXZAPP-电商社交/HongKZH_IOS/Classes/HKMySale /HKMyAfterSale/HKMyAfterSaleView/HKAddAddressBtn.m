//
//  HKAddAddressBtn.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/5.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKAddAddressBtn.h"

@implementation HKAddAddressBtn

- (instancetype)init
{
    self = [super init];
    self = [[NSBundle mainBundle]loadNibNamed:@"HKAddAddressBtn" owner:self options:nil].lastObject;
    if (self) {
        
    }
    return self;
}
- (IBAction)addAdress:(id)sender {
    if ([self.delegate respondsToSelector:@selector(gotoAddAddress)]) {
        [self.delegate gotoAddAddress];
    }
}

@end
