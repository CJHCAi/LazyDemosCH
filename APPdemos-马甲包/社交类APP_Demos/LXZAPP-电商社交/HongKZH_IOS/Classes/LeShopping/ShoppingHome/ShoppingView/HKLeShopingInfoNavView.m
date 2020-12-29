//
//  HKLeShopingInfoNavView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKLeShopingInfoNavView.h"
@interface HKLeShopingInfoNavView()
@property (weak, nonatomic) IBOutlet UIButton *cartBtn;

@end

@implementation HKLeShopingInfoNavView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self = [[NSBundle mainBundle]loadNibNamed:@"HKLeShopingInfoNavView" owner:self options:nil].lastObject;
    if (self) {
        self.frame = frame;
    }
    return self;
}
- (IBAction)btnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(gotoVc:)]) {
        [self.delegate gotoVc:sender.tag];
    }
    
}
-(void)setIsHideCart:(BOOL)isHideCart{
    _isHideCart = isHideCart;
    self.cartBtn.hidden = isHideCart;
}
@end
