//
//  HKFriendListHeadView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKFriendListHeadView.h"

@implementation HKFriendListHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self = [[NSBundle mainBundle]loadNibNamed:@"HKFriendListHeadView" owner:self options:nil].lastObject;
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
- (IBAction)friendRecommend:(id)sender {
    if ([self.delegate respondsToSelector:@selector(gotoRecommend)]) {
        [self.delegate gotoRecommend];
    }
}

@end
