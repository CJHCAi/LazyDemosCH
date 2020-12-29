//
//  HKDetailsNavView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKDetailsNavView.h"
@interface HKDetailsNavView()
@property (weak, nonatomic) IBOutlet UIButton *cartbtn;

@end

@implementation HKDetailsNavView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self = [[NSBundle mainBundle]loadNibNamed:@"HKDetailsNavView" owner:self options:nil].lastObject;
    if (self) {
        self.frame = frame;
        self.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0];
    }
    return self;
}
- (IBAction)btnClick:(UIButton *)sender {
    switch (sender.tag) {
        case 0:
        {
            if ([self.delegate respondsToSelector:@selector(backToVc)]) {
                [self.delegate backToVc];
            }
        }
            break;
        case 1:
        {
            if ([self.delegate respondsToSelector:@selector(toCart)]) {
                [self.delegate toCart];
            }
        }
            break;
        case 2:
        {
            if ([self.delegate respondsToSelector:@selector(toMore)]) {
                [self.delegate toMore];
            }
        }
            break;
        default:
            break;
    }
}
-(void)setIsHideCart:(BOOL)isHideCart{
    _isHideCart = isHideCart;
    self.cartbtn.hidden = isHideCart;
}
@end
