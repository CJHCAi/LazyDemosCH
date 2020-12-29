//
//  DIYView.m
//  SeeFood
//
//  Created by 陈伟捷 on 15/11/25.
//  Copyright © 2015年 纪洪波. All rights reserved.
//

#import "DIYView.h"

@implementation DIYView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = frame.size.width / 2 - 10;
        _seasoning = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, width, frame.size.height)];
        _seasoning.font = [UIFont systemFontOfSize:14];
        _seasoning.textColor = [UIColor darkGrayColor];
        [self addSubview:_seasoning];
        
        _usage = [[UILabel alloc]initWithFrame:CGRectMake(width + 10, 0, width, frame.size.height)];
        _usage.font = [UIFont systemFontOfSize:14];
        _usage.textColor = [UIColor darkGrayColor];
        [self addSubview:_usage];
        
        // 分割线
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, frame.size.width, 1)];
        lineView.backgroundColor = [UIColor grayColor];
        lineView.alpha = 0.5;
        [self addSubview:lineView];
    }
    return self;
}

@end
