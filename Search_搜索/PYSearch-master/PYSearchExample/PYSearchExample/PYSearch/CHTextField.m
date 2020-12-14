//
//  CHTextField.m
//  tyzx
//
//  Created by 蔡建华 on 2019/9/3.
//  Copyright © 2019 ch. All rights reserved.
//

#import "CHTextField.h"

@implementation CHTextField

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        self.layer.cornerRadius = self.height/2;
//        self.layer.masksToBounds = YES;
//        self.font = [UIFont systemFontOfSize:13];
        
        // 通过init初始化的控件大多都没有尺寸
        UIImageView *searchIcon = [[UIImageView alloc] init];
        searchIcon.image = [UIImage imageNamed:@"searchIcon"];
        searchIcon.contentMode = UIViewContentModeCenter;
        searchIcon.bounds = CGRectMake(0, 0, 30, 30);
        self.leftView = searchIcon;
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    return self;
}

@end
