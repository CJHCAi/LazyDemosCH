//
//  LQProgressLine.h
//  LQProgressLine
//
//  Created by 李强 on 16/7/20.
//  Copyright © 2016年 李强. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LQProgressLine : UIView
/**
 *  背景色
 */
@property (nonatomic,copy) NSString *backColor;
/**
 *  已经经过的进度的颜色
 */
@property (nonatomic,copy) NSString *didColor;
/**
 *  进度
 */
@property (nonatomic,assign) CGFloat progress;
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

/**
 *  工厂方法
 *
 *  @param bColor 背景颜色 (例如"#ffffff")
 *  @param dColor 已经经过的进度的颜色(例如"#000000")
 *
 *  @return 对象
 */
+(instancetype)progressLineWithBackColor:(NSString *)bColor didColor:(NSString *)dColor;
//+(instancetype)progressLineWithFrame:(CGRect)frame;

@end
