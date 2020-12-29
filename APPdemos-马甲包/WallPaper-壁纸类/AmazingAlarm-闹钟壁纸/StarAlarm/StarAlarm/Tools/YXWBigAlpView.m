//
//  YXWBigAlpView.m
//  StarAlarm
//
//  Created by 谢丰泽 on 16/4/13.
//  Copyright © 2016年 YYL. All rights reserved.
//

#import "YXWBigAlpView.h"

@implementation YXWBigAlpView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remove)];
        [self addGestureRecognizer:tap];
    
    }
    return self;
}

- (void)remove{
    [self removeFromSuperview];
    self.blockRemove();
}


@end
