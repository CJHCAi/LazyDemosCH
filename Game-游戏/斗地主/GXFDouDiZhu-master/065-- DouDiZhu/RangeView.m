//
//  RangeView.m
//  065-- DouDiZhu
//
//  Created by 顾雪飞 on 17/5/23.
//  Copyright © 2017年 顾雪飞. All rights reserved.
//

#import "RangeView.h"

@implementation RangeView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.userInteractionEnabled = YES;
        self.image = [UIImage imageNamed:@"rangebg"];
        
        UILabel *label = [UILabel new];
        label.textColor = [UIColor colorWithRed:49/255.0 green:200/255.0 blue:242/255.0 alpha:1.0];
        label.font = [UIFont systemFontOfSize:13];
        label.text = @"正在获取信息，若长时间无法显示请检查网络状况";
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(60);
            make.centerX.equalTo(self);
        }];
        
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
}

@end
