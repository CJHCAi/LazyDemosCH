//
//  HKNavSearchView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKNavSearchView.h"

@implementation HKNavSearchView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"HKNavSearchView" owner:self options:nil].firstObject;
        self.textField.layer.cornerRadius = 15;
        self.textField.layer.masksToBounds = YES;
        self.textField.backgroundColor = [UIColor colorFromHexString:@"EEEEEE"];
        UIView*leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        UIImageView*imageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 20, 20)];
        self.textField.leftViewMode = UITextFieldViewModeAlways;
        imageV.image = [UIImage imageNamed:@"look_sear"];
        [leftView addSubview:imageV];
        self.textField.leftView = leftView;
        self.textField.returnKeyType = UIReturnKeySearch;
    }
    return self;
}
- (IBAction)closeClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(closeSearch)]) {
        [self.delegate closeSearch];
    }
}


@end
