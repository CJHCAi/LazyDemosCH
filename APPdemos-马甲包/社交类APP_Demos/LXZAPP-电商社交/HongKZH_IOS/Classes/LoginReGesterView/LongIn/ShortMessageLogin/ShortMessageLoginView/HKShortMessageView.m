//
//  HKShortMessageView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/22.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKShortMessageView.h"

@implementation HKShortMessageView


- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"HKShortMessageView" owner:self options:nil].lastObject;
        self.countryBtn.hidden =YES;
        self.nextBtn.layer.cornerRadius = 4;
        self.nextBtn.layer.masksToBounds= YES;
    
    }
    return self;
}
- (IBAction)ShowLoadingView:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(showLoginViews)]) {
        [self.delegate showLoginViews];
    }
}
- (IBAction)next:(UIButton *)sender {
    DLog(@"");//
    if ([self.delegate respondsToSelector:@selector(nextToVc)]) {
        [self.delegate nextToVc];
    }
}

@end
