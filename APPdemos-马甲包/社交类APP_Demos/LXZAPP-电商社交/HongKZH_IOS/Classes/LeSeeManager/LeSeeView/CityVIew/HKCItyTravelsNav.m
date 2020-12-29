//
//  HKCItyTravelsNav.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCItyTravelsNav.h"

@implementation HKCItyTravelsNav
- (instancetype)initWithBack:(NavBackBlock)backBlock
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"HKCItyTravelsNav" owner:self options:nil].lastObject;
        self.backBlock = backBlock;
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0];
}
+(instancetype)cItyTravelsNavWIthBack:(NavBackBlock)backBlock{
    return [[HKCItyTravelsNav alloc]initWithBack:backBlock];
}
- (IBAction)backClick:(id)sender {
    if (self.backBlock) {
        self.backBlock();
    }
}

@end
