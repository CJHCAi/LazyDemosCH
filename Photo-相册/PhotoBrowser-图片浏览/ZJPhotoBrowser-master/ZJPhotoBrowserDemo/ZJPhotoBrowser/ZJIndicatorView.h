//
//  ZJIndicatorView.h
//  ZJPhotoBrowserDemo
//
//  Created by 陈志健 on 2017/4/13.
//  Copyright © 2017年 chenzhijian. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    IndicatorViewModeLoopDiagram, // 环形
    IndicatorViewModePieDiagram // 饼型
} IndicatorViewMode;

typedef enum {
    IndicatorViewStatusLoading, // 加载中
    IndicatorViewStatusSuccess, // 成功
    IndicatorViewStatusFalid    // 失败
} IndicatorViewStatus;


#define kIndicatorViewBackgroundColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]
#define kIndicatorViewItemMargin 10
#define kIndicatorViewWidth 40

@interface ZJIndicatorView : UIView

@property (nonatomic, assign) CGFloat progress;//进度
@property (nonatomic, assign) IndicatorViewMode viewMode;//显示模式
@property (nonatomic, assign) IndicatorViewStatus status;//显示模式

+ (instancetype)indicatorShowInView:(UIView *)view;

- (void)hideIndicatorViewWithSucceed:(BOOL)succeed;

@end
