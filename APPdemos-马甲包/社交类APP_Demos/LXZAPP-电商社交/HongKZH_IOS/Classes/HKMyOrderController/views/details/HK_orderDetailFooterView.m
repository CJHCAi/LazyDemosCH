//
//  HK_orderDetailFooterView.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_orderDetailFooterView.h"

@implementation HK_orderDetailFooterView

-(instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        self.backgroundColor =UICOLOR_RGB_Alpha(0xf2f2f2, 1);
        [self addSubview:self.rightBtn];

    }
    return self;
}

-(UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _rightBtn;
}



@end
