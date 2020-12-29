//
//  HKMyCiecleHeadView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyCiecleHeadView.h"

@implementation HKMyCiecleHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self = [[NSBundle mainBundle]loadNibNamed:@"HKMyCiecleHeadView" owner:self options:nil].lastObject;
    if (self) {
        self.frame = frame;
    }
    return self;
}
- (IBAction)seacch:(id)sender {
    if ([self.delegate respondsToSelector:@selector(gotoSearch)]) {
        [self.delegate gotoSearch];
    }
}
- (IBAction)gotoVc:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(clickWithRow:)]) {
        [self.delegate clickWithRow:(int)sender.tag];
    }
}

@end
