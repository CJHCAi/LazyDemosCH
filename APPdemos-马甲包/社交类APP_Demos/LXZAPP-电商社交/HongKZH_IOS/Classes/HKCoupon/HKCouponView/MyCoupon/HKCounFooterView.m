//
//  HKCounFooterView.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCounFooterView.h"

@implementation HKCounFooterView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self =[super initWithFrame:frame]) {
        self.backgroundColor = MainColor
        [self addSubview:self.footMessageLabel];
    }
    return  self;
}

-(UILabel *)footMessageLabel {
    if (!_footMessageLabel) {
        _footMessageLabel =[[UILabel alloc] initWithFrame:CGRectMake(0,10,kScreenWidth,15)];
        [AppUtils getConfigueLabel:_footMessageLabel font:PingFangSCRegular10 aliment:NSTextAlignmentCenter textcolor:RGBA(153,153,153,1) text:@"亲 我也是有底线的"];
    }
    return _footMessageLabel;
}


@end
