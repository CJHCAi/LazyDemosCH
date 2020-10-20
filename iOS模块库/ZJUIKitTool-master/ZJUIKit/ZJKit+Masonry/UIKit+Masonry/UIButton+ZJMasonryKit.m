//
//  UIButton+ZJMasonryKit.m
//  ZJUIKit
//
//  Created by dzj on 2018/1/18.
//  Copyright © 2018年 kapokcloud. All rights reserved.
//

#import "UIButton+ZJMasonryKit.h"

@implementation UIButton (ZJMasonryKit)


/**
 * 快速创建UIButton，设置：父视图，Marsonry布局
 
 @param touchUp         点击事件
 @return                返回一个button
 */
+(instancetype)zj_buttonWithOnTouchUp:(ZJButtonBlock)touchUp{
    return [self zj_buttonWithOnTouchUp:touchUp];
}

/**
 * 快速创建UIButton，设置：父视图，Marsonry布局
 
 @param supView         父视图
 @param constaints      Marsonry布局
 @param touchUp         点击事件
 @return                返回一个button
 */
+(instancetype)zj_buttonWithSupView:(UIView *)supView
                        constraints:(ZJConstrainMaker)constaints
                            touchUp:(ZJButtonBlock)touchUp{
    return [self zj_buttonWithNorImage:nil cornerRadius:0 supView:supView constraints:constaints touchUp:touchUp];
}


/**
 * 快速创建UIButton，设置：标题，父视图，Marsonry布局
 
 @param title    圆角
 @param superView         父视图
 @param constraints      Marsonry布局
 @param touchUp         点击事件
 @return                返回一个button
 */
+ (instancetype)zj_buttonWithTitle:(NSString *)title
                          superView:(UIView *)superView
                        constraints:(ZJConstrainMaker)constraints
                            touchUp:(ZJButtonBlock)touchUp
{
    return [self zj_buttonWithTitle:title titleColor:nil norImage:nil selectedImage:nil backColor:nil fontSize:0 isBold:NO cornerRadius:0 supView:superView constraints:constraints touchUp:touchUp];
}
/**
 * 快速创建UIButton，设置：默认图片，圆角，父视图，Marsonry布局
 
 @param cornerRadius    圆角
 @param supView         父视图
 @param constaints      Marsonry布局
 @param touchUp         点击事件
 @return                返回一个button
 */
+(instancetype)zj_buttonWithNorImage:(id)norImage
                        cornerRadius:(CGFloat)cornerRadius
                             supView:(UIView *)supView
                         constraints:(ZJConstrainMaker)constaints
                             touchUp:(ZJButtonBlock)touchUp
{
    return [self zj_buttonWithTitle:nil titleColor:nil norImage:norImage selectedImage:nil backColor:nil fontSize:0 isBold:0 cornerRadius:cornerRadius supView:supView constraints:constaints touchUp:touchUp];
}

/**
 * 快速创建UIButton，设置：标题，标题颜色，背景颜色，字体大小，是否加粗，圆角，父视图，Marsonry布局
 
 @param title           标题
 @param titleColor      标题颜色
 @param backColor       背景颜色
 @param fontSize        字体大小
 @param isBold          是否加粗
 @param cornerRadius    圆角
 @param supView         父视图
 @param constaints      Marsonry布局
 @param touchUp         点击事件
 @return                返回一个button
 */
+(instancetype)zj_buttonWithTitle:(NSString *)title
                       titleColor:(UIColor *)titleColor
                        backColor:(UIColor *)backColor
                         fontSize:(CGFloat)fontSize
                           isBold:(BOOL)isBold
                     cornerRadius:(CGFloat)cornerRadius
                          supView:(UIView *)supView
                      constraints:(ZJConstrainMaker)constaints
                          touchUp:(ZJButtonBlock)touchUp
{
    return [self zj_buttonWithTitle:title
                         titleColor:titleColor
                           norImage:nil
                      selectedImage:nil
                          backColor:backColor
                           fontSize:fontSize
                             isBold:isBold
                       cornerRadius:cornerRadius
                            supView:supView
                        constraints:constaints
                            touchUp:touchUp];
}


/**
 * 快速创建UIButton，设置：标题，标题颜色，默认图片，选中的图片，背景颜色，字体大小，是否加粗，圆角，父视图，Marsonry布局
 
 @param title           标题
 @param titleColor      标题颜色
 @param norImage        默认图片
 @param selectImage        选中的图片
 @param backColor       背景颜色
 @param fontSize        字体大小
 @param isBold          是否加粗
 @param cornerRadius    圆角
 @param supView         父视图
 @param constaints      Marsonry布局
 @param touchUp         点击事件
 @return                返回一个button
 */
+(instancetype)zj_buttonWithTitle:(NSString *)title
                       titleColor:(UIColor *)titleColor
                         norImage:(id)norImage
                    selectedImage:(id)selectImage
                        backColor:(UIColor *)backColor
                         fontSize:(CGFloat)fontSize
                           isBold:(BOOL)isBold
                     cornerRadius:(CGFloat)cornerRadius
                          supView:(UIView *)supView
                      constraints:(ZJConstrainMaker)constaints
                          touchUp:(ZJButtonBlock)touchUp
{
    return [self zj_buttonWithTitle:title titleColor:titleColor norImage:norImage selectedImage:selectImage backColor:backColor fontSize:fontSize isBold:isBold borderWidth:0 borderColor:nil cornerRadius:cornerRadius supView:supView constraints:constaints touchUp:touchUp];
}

/**
 * 快速创建UIButton，设置：标题，标题颜色，默认图片，选中的图片，背景颜色，字体大小，是否加粗，边框宽度，边框颜色，圆角，父视图，Marsonry布局
 
 @param title           标题
 @param titleColor      标题颜色
 @param norImage        默认图片
 @param selectImage        选中的图片
 @param backColor       背景颜色
 @param fontSize        字体大小
 @param isBold          是否加粗
 @param borderWidth     边框宽度
 @param borderColor     边框颜色
 @param cornerRadius    圆角
 @param supView         父视图
 @param constaints      Marsonry布局
 @param touchUp         点击事件
 @return                返回一个 button
 */
+(instancetype)zj_buttonWithTitle:(NSString *)title
                       titleColor:(UIColor *)titleColor
                         norImage:(id)norImage
                    selectedImage:(id)selectImage
                        backColor:(UIColor *)backColor
                         fontSize:(CGFloat)fontSize
                           isBold:(BOOL)isBold
                      borderWidth:(CGFloat)borderWidth
                      borderColor:(UIColor *)borderColor
                     cornerRadius:(CGFloat)cornerRadius
                          supView:(UIView *)supView
                      constraints:(ZJConstrainMaker)constaints
                          touchUp:(ZJButtonBlock)touchUp
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.zj_onTouchUp = touchUp;
    
    if (!kIsEmptyString(title)) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    if (titleColor) {
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    }else{
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    
    UIImage *normalImage = nil;
    if ([norImage isKindOfClass:[NSString class]]) {
        normalImage = kImageName(norImage);
    }else if([norImage isKindOfClass:[UIImage class]]){
        normalImage = norImage;
    }
    
    UIImage *seleImage = nil;
    if ([selectImage isKindOfClass:[NSString class]]) {
        seleImage = kImageName(selectImage);
    }else if([selectImage isKindOfClass:[UIImage class]]){
        seleImage = selectImage;
    }
    
    if (normalImage) {
        [button setImage:normalImage forState:UIControlStateNormal];
    }
    
    if (seleImage) {
        [button setImage:seleImage forState:UIControlStateSelected];
    }
    
    if (fontSize > 0) {
        if (isBold) {
            button.titleLabel.font = kBoldFontWithSize(fontSize);
        }else{
            button.titleLabel.font = kFontWithSize(fontSize);
        }
    }
    
    [button setBackgroundColor:backColor];
    
    button.layer.cornerRadius = cornerRadius;
    if (borderWidth) {
        button.layer.borderWidth = borderWidth;
        button.layer.borderColor = borderColor.CGColor;
    }
    
    [supView addSubview:button];
    
    if (supView && constaints) {
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            constaints(make);
        }];
    }
    
    return button;
}

@end
