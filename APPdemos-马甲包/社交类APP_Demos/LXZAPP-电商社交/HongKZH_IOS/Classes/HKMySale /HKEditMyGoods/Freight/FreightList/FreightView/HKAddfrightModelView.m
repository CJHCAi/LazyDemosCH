//
//  HKAddfrightModelView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKAddfrightModelView.h"

@implementation HKAddfrightModelView

- (instancetype)init
{
    self = [super init];
    self = [[NSBundle mainBundle]loadNibNamed:@"HKAddfrightModelView" owner:self options:nil].lastObject;
    if (self) {
        
    }
    return self;
}
- (IBAction)clickBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(addModel)]) {
        [self.delegate addModel];
    }
}

@end
