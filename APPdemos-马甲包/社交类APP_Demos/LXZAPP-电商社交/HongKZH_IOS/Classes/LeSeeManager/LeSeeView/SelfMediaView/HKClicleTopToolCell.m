//
//  HKClicleTopToolCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKClicleTopToolCell.h"

@implementation HKClicleTopToolCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(IBAction)clickBtn:(UIButton*)sender{
    
    [self.delegate clickWithTag:sender.tag];
}
@end
