//
//  HKRobRedFailView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKRobRedFailView.h"
@interface HKRobRedFailView()

@end

@implementation HKRobRedFailView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"HKRobRedFailView" owner:self options:nil].lastObject;
    }
    return self;
}
- (IBAction)gotoShare:(id)sender {
    if ([self.delegate respondsToSelector:@selector(shareToVc)]) {
        [self.delegate shareToVc];
    }
}

@end
