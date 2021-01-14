//
//  HQDrawingView.h
//  HQDrawingBoard
//
//  Created by zfwlxt on 17/3/15.
//  Copyright © 2017年 何晴. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SaveSuccessBlock)();

@interface HQDrawingView : UIView

// 用来设置线条的颜色
@property (nonatomic, strong) UIColor *color;
// 用来设置线条的宽度
@property (nonatomic, assign) CGFloat lineWidth;
// 用来记录已有线条
@property (nonatomic, strong) NSMutableArray *allLines;

// 初始化相关参数
- (void)initDrawingView;
// back操作
- (void)doBack;
// Forward操作
- (void)doForward;
// 保存Image
- (void)saveImage:(SaveSuccessBlock)saveSuccessBlock;


@end
