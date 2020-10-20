//
//  CLRotationView.h
//  菁优网首页动画
//
//  Created by JackChen on 2016/12/13.
//  Copyright © 2016年 chenlin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , CL_RoundviewType) {
    CL_RoundviewTypeSystem = 0,
    CL_RoundviewTypeCustom ,
};

typedef void(^JumpBlock)(NSInteger num , NSString *name);

@interface CLRotationView : UIView

// 点击按钮时跳转控制器的逆向传值block 【可以使用代理替换】
@property (nonatomic , copy) JumpBlock back ;
// 按钮样式 -- 系统样式或者自定义样式
@property (nonatomic , assign) CL_RoundviewType Type;
// 按钮的宽度
@property (nonatomic , assign) CGFloat BtnWidth;
// 视图的宽度
@property (nonatomic , assign) CGFloat Width;
// 按钮的背景颜色
@property (nonatomic , strong) UIColor *BtnBackgroudColor ;

/**
 *  创建按钮
 *
 *  @param type        按钮的风格
 *  @param BtnWidth    按钮的宽度
 *  @param sizeWidth    字体是否自动适应按钮的宽度
 *  @param mask        是否允许剪切
 *  @param radius      圆角的大小
 *  @param image       图片数组
 *  @param titileArray 名字数组
 *  @param titleColor  字体的颜色
 */


- (void)BtnType:(CL_RoundviewType)type BtnWidth:(CGFloat)BtnWidth  adjustsFontSizesTowidth:(BOOL)sizeWidth  masksToBounds:(BOOL)mask conrenrRadius:(CGFloat)radius image:(NSMutableArray *)image TitileArray:(NSMutableArray *)titileArray titileColor:(UIColor *)titleColor;

@end
