//
//  XMAutoScrollTextView.h
//  AlphaGoFinancial
//
//  Created by 千锋 on 16/6/27.
//  Copyright © 2016年 wxm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMAutoScrollTextView : UIScrollView

/*初始化*/
-(instancetype)initWithFrame:(CGRect)frame textArray:(NSArray *)textArray colorArray:(NSArray *)textColorArray;

//滚动字幕数组
@property(nonatomic,strong) NSArray<NSString *> *textArray;

//字幕颜色数组
@property(nonatomic,strong) NSArray<UIColor *> *textColorArray;

//字幕背景颜色
@property(nonatomic,strong) UIColor *backgroundColorOfCanvas;

//标签背景图片
@property(nonatomic,strong) UIImage *backgroundImageOfCanvas;

//字体大小
@property(nonatomic,assign) CGFloat fontOfSize;

//定时器
@property(nonatomic,strong) NSTimer *timer;


@end
