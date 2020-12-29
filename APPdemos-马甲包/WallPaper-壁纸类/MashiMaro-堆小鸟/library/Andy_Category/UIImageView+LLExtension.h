//
//  UIImageView+LLExtension.h
//  Andy_Category
//
//  Created by 933 on 15/12/30.
//  Copyright © 2015年 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ImageViewButtonClickBlock)(UIButton *imageBlock);

@interface UIImageView (LLExtension)

/**
 *  创建 UIImageView
 *  @param frame    尺寸
 *  @param imageStr 图片名字
 */
+(instancetype)LL_createImageViewWithFrame:(CGRect)frame
                               imageString:(NSString *)imageString;

/**
 *  创建可点击 UIImageView
 *  @param frame    尺寸
 *  @param imageStr 图片名字
 *  @param action   回调block
 */
+(instancetype)LL_createImageViewWithFrame:(CGRect)frame
                               imageString:(NSString *)imageString
                                 actionSel:(ImageViewButtonClickBlock)action;


@end
