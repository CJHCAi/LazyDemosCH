//
//  TestZoomHeader.m
//  XLZoomHeaderDemo
//
//  Created by MengXianLiang on 2018/8/3.
//  Copyright © 2018年 mxl. All rights reserved.
//

#import "TestZoomHeader1.h"

@implementation TestZoomHeader1

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    //设置背景图
    self.image = [UIImage imageNamed:@"test_backGround"];
    
    
    //自定义内容
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
    icon.image = [UIImage imageNamed:@"test_icon"];
    icon.center = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f);
    icon.layer.cornerRadius = icon.bounds.size.height/2.0f;
    icon.clipsToBounds = true;
    icon.layer.borderWidth = 2;
    icon.layer.borderColor = [UIColor whiteColor].CGColor;
    [self addSubview:icon];
}

@end
