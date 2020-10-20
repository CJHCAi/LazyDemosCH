//
//  UIBarButtonItem+ZJExtension.h
//  WeiboDemo
//
//  Created by Zj on 16/9/12.
//  Copyright © 2016年 Zj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (ZJExtension)
/**
 *  纯文字UIBarButtonItem快速创建
 *ZJExtension
 *  @param title  标题
 *  @param target 目标
 *  @param sel    监听的点击后的方法
 *
 *  @return UIBarButtonItem
 */
+ (UIBarButtonItem *)BarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)sel;
/**
 *  纯图片UIBarButtonItem快速创建
 *
 *  @param imgName    普通状态图片名
 *  @param highImgName 高亮状态图片名
 *  @param target     目标
 *  @param sel        监听点击后的方法
 *
 *  @return UIBarButtonItem
 */
+ (UIBarButtonItem *)BarButtonItemWithImg:(NSString *)imgName highlightedImg:(NSString *)highImgName target:(id)target action:(SEL)sel;
@end
