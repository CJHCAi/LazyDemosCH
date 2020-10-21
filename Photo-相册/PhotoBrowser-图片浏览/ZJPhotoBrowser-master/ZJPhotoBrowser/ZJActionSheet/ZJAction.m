//
//  ZJAction.m
//  ZJPhotoBrowserDemo
//
//  Created by 陈志健 on 2017/4/14.
//  Copyright © 2017年 chenzhijian. All rights reserved.
//

#import "ZJAction.h"

@implementation ZJAction

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithTitle:(NSString *)title action:(void(^)())action {

    self = [super initWithFrame:CGRectMake(0, 0, kZJActionScreenWidth, kZJActionHeight)];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
        UIButton *button = [[UIButton alloc] initWithFrame:self.frame];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
        self.action = action;
        [self addSubview:button];
    }

    return self;
}

- (void)buttonAction {

    if ([self.delegate respondsToSelector:@selector(didSelectedZJAction:)]) {
        
        [self.delegate didSelectedZJAction:self];
    }
}

@end
