//
//  HKPurchaseToolView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKPurchaseToolView.h"

@implementation HKPurchaseToolView

- (instancetype)init
{
    self = [super init];
    self = [[NSBundle mainBundle]loadNibNamed:@"HKPurchaseToolView" owner:self options:nil].firstObject;
    if (self) {
        
    }
    return self;
}
- (IBAction)selects:(UIButton*)sender {
    if ([self.delegate respondsToSelector:@selector(gotoSelectParameWithTag:)]) {
        [self.delegate gotoSelectParameWithTag:sender.tag];
    }
}
- (IBAction)clickTool:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(gotoToolClick:)]) {
        [self.delegate gotoToolClick:sender.tag];
    }
}

@end
