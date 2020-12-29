//
//  UIButton+LLExtension.h
//  Andy_Category
//
//  Created by 933 on 15/12/29.
//  Copyright © 2015年 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^ButtonActionBlock) (UIButton *button);

@interface UIButton (LLExtension)

/**
 *  创建文字Button
 *
 *  @param frame           frame
 *  @param title           title
 *  @param backgroundColor 背景颜色
 *  @param titleColor      文字颜色
 *  @param actionSel       block回调
 */
+(instancetype)LL_buttonCustomButtonFrame:(CGRect)frame
                                    title:(NSString *)title
                        currentTtileColor:(UIColor *)titleColor
                                actionSel:(ButtonActionBlock)actionSel;



/**
 *  创建图片Button
 *
 *  @param frame             frame
 *  @param normalImgString   按钮的正常状态图片
 *  @param actionSel         block回调
 */
+(instancetype)LL_buttonCustomButtonFrame:(CGRect)frame 
                        normalImageString:(NSString *)normalImgString
                                actionSel:(ButtonActionBlock)actionSel;



@end
