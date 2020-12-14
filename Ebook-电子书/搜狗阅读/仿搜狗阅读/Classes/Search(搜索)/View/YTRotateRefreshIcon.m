//
//  YTRotateRefreshIcon.m
//  仿搜狗阅读
//
//  Created by Mac on 16/6/5.
//  Copyright © 2016年 YinTokey. All rights reserved.
//

#import "YTRotateRefreshIcon.h"

@implementation YTRotateRefreshIcon

#pragma mark - 重写方法
#pragma mark 基本设置
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
