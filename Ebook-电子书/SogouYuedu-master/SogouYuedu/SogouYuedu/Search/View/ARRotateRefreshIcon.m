//
//  ARRotateRefreshIcon.m
//  SogouYuedu
//
//  Created by andyron on 2017/9/26.
//  Copyright © 2017年 andyron. All rights reserved.
//

#import "ARRotateRefreshIcon.h"

@implementation ARRotateRefreshIcon

- (void)prepare
{
    [super prepare];
    
    // 设置正在刷新状态的动画图片
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=3; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"旋转%zd", i]];
        [refreshingImages addObject:image];
    }
    // 设置字体
    self.stateLabel.font = [UIFont systemFontOfSize:11];
    // 设置颜色
    self.stateLabel.textColor = RGB(126, 127, 126);
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
}

@end
