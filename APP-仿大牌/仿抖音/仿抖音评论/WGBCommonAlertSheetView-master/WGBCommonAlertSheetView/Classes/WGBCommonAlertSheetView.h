//
//  WGBCommonAlertSheetView.h
//
//  Created by mac on 2019/9/2.
//  Copyright © 2019 CoderWGB. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WGBCommonAlertSheetViewBlurEffectStyle) {
    WGBCommonAlertSheetViewBlurEffectStyleLight = 1,
    WGBCommonAlertSheetViewBlurEffectStyleDark
} ;


NS_ASSUME_NONNULL_BEGIN

@interface WGBCommonAlertSheetView : UIView

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;

/**
 ///MARK:- 唯一指定创建构造器

 @param frame 一般情况设置全屏就完事了
 @param containerView 具有frame的容器视图
 @return 还你一个类似抖音评论的触底反弹的视图
 */
- (instancetype)initWithFrame:(CGRect)frame containerView:(UIView *)containerView;

// 蒙层的透明度 默认0.35
@property (nonatomic,assign) CGFloat maskAlpha;

//触摸蒙层dismiss 默认为YES
@property (nonatomic,assign) BOOL touchDismiss;

//默认YES 是否需要弹性 即触底反弹的特性
@property (nonatomic,assign) BOOL bounce;

//是否需要毛玻璃 默认是NO
@property (nonatomic,assign) BOOL isNeedBlur;

//毛玻璃的样式 这个必须设置不然没有任何效果 前提是`isNeedBlur=YES`
@property (nonatomic,assign) WGBCommonAlertSheetViewBlurEffectStyle blurStyle;

//展示到指定父视图上 superView为空即默认为放在主窗口keywindow上
- (void)showAlertWithSuperView:(UIView * _Nullable)superView ;

//展示
- (void)show;

//移除消失
- (void)dismiss;

@property (nonatomic,copy) dispatch_block_t showCompletionBlock; //展示之后
@property (nonatomic,copy) dispatch_block_t dismissCompletionBlock;//消失之后


@end

NS_ASSUME_NONNULL_END
