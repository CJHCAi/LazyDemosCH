//
//  HKPlaceOrder.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/17.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKPlaceOrder.h"
@interface HKPlaceOrder()
@property (weak, nonatomic) IBOutlet UILabel *num;

@end

@implementation HKPlaceOrder

- (instancetype)init
{
    self = [super init];
    self = [[NSBundle mainBundle]loadNibNamed:@"HKPlaceOrder" owner:self options:nil].lastObject;
    if (self) {
        
    }
    return self;
}
- (IBAction)placeOrderClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(placeOrder)]) {
        [self.delegate placeOrder];
    }
}
-(void)setNumAll:(double)numAll{
    _numAll = numAll;
    self.num.text = [NSString stringWithFormat:@"¥%.2lf",numAll];
}
@end
