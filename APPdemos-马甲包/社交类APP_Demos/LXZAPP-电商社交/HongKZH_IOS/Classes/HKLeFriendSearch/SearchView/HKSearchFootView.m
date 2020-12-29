//
//  HKSearchFootView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/24.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSearchFootView.h"
@interface HKSearchFootView()
@property (weak, nonatomic) IBOutlet UILabel *textL;
@end

@implementation HKSearchFootView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"HKSearchFootView" owner:self options:nil].lastObject;
    }
    return self;
}
- (IBAction)footerClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(footerClickWithType:)]) {
        [self.delegate footerClickWithType:self.type];
    }
}
-(void)setType:(int)type{
    _type = type;
    if (type == 0) {
        self.textL.text = @"查看更多好友";
    }else{
        self.textL.text = @"查看更多消息";
    }
}
@end
