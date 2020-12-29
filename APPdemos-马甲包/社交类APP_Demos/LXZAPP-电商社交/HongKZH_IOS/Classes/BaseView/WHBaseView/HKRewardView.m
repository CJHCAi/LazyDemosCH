//
//  HKRewardView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKRewardView.h"

@implementation HKRewardView

-(void)awakeFromNib{
    [super awakeFromNib];
    
}
- (instancetype)init
{
    self = [super init];
    self = [[NSBundle mainBundle]loadNibNamed:@"HKRewardView" owner:self options:nil].firstObject;
    if (self) {
      self.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.8];
    }
    return self;
}
- (IBAction)showEdit:(id)sender {
    if ([self.delegate respondsToSelector:@selector(gotoShowedit)]) {
        [self.delegate gotoShowedit];
    }
}
- (IBAction)selectMoney:(UIButton*)sender {
    if ([self.delegate respondsToSelector:@selector(confirmWithNum:)]) {
        [self.delegate confirmWithNum:sender.tag];
    }
}
- (IBAction)closeClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(hideView)]) {
        [self.delegate hideView];
    }
}
@end
