//
//  CQTopBarViewController.h
//  CQTopBar
//
//  Created by CQ on 2018/1/9.
//  Copyright © 2018年 CQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CQTopBarViewController : UIViewController

/**
 * 修改segment文字
 * indexes:需要修改第几个文字
 * objects:需要修改文字内容
 */
- (void)topBarReplaceObjectsAtIndexes:(NSUInteger)indexes withObjects:(id _Nullable )objects;

/**
 是否隐藏当前显示View
 */
@property (nonatomic, assign) BOOL hiddenView;

/**
 segment的footerView
 */
@property (nonatomic, strong) UIView * _Nullable footerView;

/**
 设置位置和大小:默认: x=0, y=64，w=屏幕的宽度, h=40
 */
@property (nonatomic, assign) CGRect segmentFrame;

/**
 需要显示的文本数组
 */
@property (nonatomic, strong) NSArray * _Nullable sectionTitles;

/**
 要加载的ViewController，传ClassName即可
 */
@property(nonatomic, strong) NSArray * _Nullable pageViewClasses;

/**
 不选中时文本的颜色
 */
@property (nonatomic, strong) UIColor * _Nullable titleTextColor UI_APPEARANCE_SELECTOR;

/**
 选中文本的颜色
 */
@property (nonatomic, strong) UIColor * _Nullable selectedTitleTextColor UI_APPEARANCE_SELECTOR;

/**
 需要显示的文本字体
 */
@property (nonatomic, strong) UIFont * _Nullable titleTextFont;

/**
 未选中后的图标
 */
@property (nonatomic, strong) NSString * _Nullable segmentImage;

/**
 选中后的图标
 */
@property (nonatomic, strong) NSString * _Nullable selectSegmentImage;

/**
 线条的颜色
 */
@property (nonatomic, strong) UIColor * _Nullable segmentlineColor;

/**
 未选中的背景色
 */
@property (nonatomic, strong) UIColor * _Nullable segmentbackColor;

/**
 选中的背景色
 */
@property (nonatomic, strong) UIColor * _Nullable selectSegmentbackColor;

/**
 未选中的背景图
 */
@property (nonatomic, strong) UIImage * _Nullable segmentbackImage;

/**
 选中的背景图
 */
@property (nonatomic, strong) UIImage * _Nullable selectSegmentbackImage;

@end
