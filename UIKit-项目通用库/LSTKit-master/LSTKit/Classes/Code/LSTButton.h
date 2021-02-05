//
//  LSTButton.h
//  LSTButton
//
//  Created by LoSenTrad on 2018/2/19.
//  Copyright © 2018年 LoSenTrad. All rights reserved.
//

#import <UIKit/UIKit.h>

//按钮图文布局样式
typedef NS_ENUM(NSUInteger,LSTButtonImageType) {
    LSTButtonImageTypeLeft,    //系统默认样式,左图右文字
    LSTButtonImageTypeTop,     //上图下文字
    LSTButtonImageTypeBottom,  //下图上文字
    LSTButtonImageTypeRight    //右图左文字
};


/** badge样式 */
typedef NS_ENUM(NSUInteger, LSTBadgeType) {
    LSTBadgeTypePoint,  //默认小红点
    LSTBadgeTypeNew,    //小红点new标识
    LSTBadgeTypeNumber, //小红点数量
    LSTBadgeTypeCustom  //自定义图片
};

/** badge 动画样式 */
typedef NS_ENUM(NSUInteger, LSTBadgeAnimationType) {
    LSTBadgeAnimationTypeNone,     //无动画
    LSTBadgeAnimationTypeShake,    //抖动
    LSTBadgeAnimationTypeOpacity,  //透明过渡动画
    LSTBadgeAnimationTypeScale,    //缩放动画
};


@interface LSTButton : UIButton



/** 是否根据文字内容自适应宽度 默认为NO */
@property (nonatomic,assign) BOOL isAdaptiveWidth;
/** 按钮图文布局样式 */
@property (nonatomic,assign) LSTButtonImageType imageType;
/** 按钮图文间距 默认为6.0f */
@property (nonatomic,assign) CGFloat imageTextSpacing;

//*********************文字属性设置
/** 按钮文字内容 UIControlStateNormal状态 */
@property (nonatomic,copy) NSString *title;
/** 按钮文字大小 默认是15 UIControlStateNormal状态 */
@property (nonatomic,strong) UIFont *titleFont;
/** 按钮文字颜色 默认是黑色 UIControlStateNormal状态 */
@property (nonatomic,strong) UIColor *titleColor;
/** 标题对齐 */
@property (nonatomic,assign) NSTextAlignment titleAlignment;;
//*********************图片相关属性设置
@property (nonatomic,strong) UIImage *image;
/** 图片大小 */
@property (nonatomic,assign) CGSize imageSize;
/** 圆角处理 默认是UIRectCornerAllCorners上下左右4圆角 */
@property (nonatomic,assign) UIRectCorner corners;
/** 圆角大小 默认是0 */
@property (nonatomic,assign) CGFloat cornerRadius;
/** 图片 */
@property (nonatomic,assign) UIViewContentMode imageContentMode;


//*********************背景相关属性设置
/** 背景颜色 默认白色 */
@property (nonatomic, strong) UIColor *backgroundColor;
/** 背景图 默认为nil */
@property (nonatomic, strong) UIImage *backgroundImage;

//*********************边框相关属性设置
/** 边框线条颜色 (默认 clearColor) */
@property (nonatomic, strong) UIColor *borderColor;
/** 边框线条宽度 (默认 0 ) */
@property (nonatomic, assign) CGFloat borderWidth;

//*********************badge相关属性设置
/** BadgeView数值或者是文字 只对LSTBadgeTypeNumber和LSTBadgeTypeNew有效 */
@property (nonatomic,copy) NSString *badgeText;
/** BadgeView数值或者文字颜色 默认白色 只对LSTBadgeTypeNumber和LSTBadgeTypeNew有效 */
@property (nonatomic,strong) UIColor *badgeTextColor;
/** BadgeView数值或者文字字体大小 只对LSTBadgeTypeNumber和LSTBadgeTypeNew有效 */
@property (nonatomic,strong) UIFont *badgeTextFont;
/** BadgeView大小 */
@property (nonatomic,assign) CGSize badgeSize;
/** BadgeView样式 */
@property (nonatomic,assign) LSTBadgeType badgeType;
/** BadgeView动画类型 */
@property (nonatomic,assign) LSTBadgeAnimationType badgeAnimationType;
/** BadgeView显示颜色 LSTBadgeTypeCustom样式不生效 */
@property (nonatomic,strong) UIColor *badgeColor;
/** BadgeView位置 */
@property (nonatomic,assign) CGPoint badgeOffset;
/** BadgeView圆角大小 默认是(badgeSize.Height)/2 */
@property (nonatomic,assign) CGFloat badgeRadius;
/** BadgeView是否可以拖动消除 */
@property (nonatomic,assign) BOOL isBadgeMove;

+ (instancetype)buttonWithFrame:(CGRect)frame;

/** 显示BadgeView(根据属性配置显示) */
//- (void)showBadgeView;
/** 移除BadgeView */
//- (void)dismissBadgeView;

@end
