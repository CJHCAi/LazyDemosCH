//
//  ZJCycleView.h
//  ZJCollectionViewSummary
//
//  Created by James on 2018/6/9.
//  Copyright © 2018年 James. All rights reserved.
//

/**
 项目地址：https://github.com/zhijiaxin/ZJCollectionViewSummary.git
 
 也可以到博客下看看相关介绍
 博客地址：https://www.jianshu.com/p/ff7089782d6c
 
 有什么错误或使用不便的地方可以留言或加我QQ
 
 QQ：1224740397
 */

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZJCycleViewType)
{
    CycleViewImage                  = 1,
    CycleViewSeparateTitleAndImage  = 1 << 1,
    CycleViewMergeTitleAndImage     = 1 << 2,
};

/** 可以定义PageContol圆点的类型 */
typedef NS_ENUM(NSInteger, ZJCyclePageContolStyle) {
    ZJCyclePageContolStyleNone,     //圆点
    ZJCyclePageContolStyleRectangle,//条状
    ZJCyclePageContolStyleImage,    //图片
};

/** 可以定义PageContol圆点的类型 */
typedef NS_ENUM(NSInteger, ZJCyclePageContolLocation) {
    ZJCyclePageContolLocationCenter,//中间
    ZJCyclePageContolLocationLeft, //左边
    ZJCyclePageContolLocationRight,//右边
};

@class ZJCycleView;

@protocol ZJCycleViewDelegate <NSObject>

@optional

/** 点击图片回调 */
- (void)cycleView:(ZJCycleView *)cycleView didSelectItemAtIndex:(NSInteger)index;

/** 图片滚动回调 */
- (void)cycleView:(ZJCycleView *)cycleView didCycleToIndex:(NSInteger)index;

@end

@interface ZJCycleView : UIView

@property (nonatomic, weak) id <ZJCycleViewDelegate> delegate;

/** 本地图片 */
@property (nonatomic, strong) NSArray<NSString *> *images;
/** 图片链接 */
@property (nonatomic, strong) NSArray<NSString *> *urlA;
/** 每张图片对应要显示的文字数组 */
@property (nonatomic, strong) NSArray *titles;

/** 图片和标题字典（字典结构为：@{@"imageUrl":@"",@"title":@""}） */
@property (nonatomic, strong) NSArray<NSDictionary *> *arrayD;

@property (nonatomic, assign) ZJCycleViewType cycleViewType;

/** 自动轮播时间间隔,默认2s */
@property (nonatomic, assign) CGFloat autoCycleTimeInterval;

/** 是否无限循环,默认Yes */
@property (nonatomic,assign) BOOL isInfiniteCycle;

/** 是否自动轮播,默认Yes */
@property (nonatomic,assign) BOOL autoCycle;

/** 是否显示分页控件 */
@property (nonatomic, assign) BOOL showPageControl;

/** 分页控件的位置 */
@property (nonatomic, assign) ZJCyclePageContolLocation pageControlLocation;

/** pageContol点的样式 */
@property (nonatomic, assign) ZJCyclePageContolStyle pageContolStyle;

/**
初始化方法

@param frame 位置尺寸
@param imageUrls 需要加载的图片数组，可以是本地的，也可以是网络的图片
@param placeholderImage 占位图片
@return ZJCycleView对象
*/
- (instancetype)initWithFrame:(CGRect)frame
                imageUrls:(NSArray <NSString *> *)imageUrls
         placeholderImage:(UIImage*)placeholderImage;

/**
初始化方法：图片带文字说明的不显示分页控件，但是会有总数和当前页的显示：2/20

@param frame 位置尺寸
@param imageUrls 需要加载的图片数组，可以是本地的，也可以是网络的图片
@param titles 每张图片对应要显示的文字数组
@param placeholderImage 占位图片
@return ZJCycleView对象
*/
- (instancetype)initWithFrame:(CGRect)frame
                imageUrls:(NSArray <NSString *> *)imageUrls
                   titles:(NSArray <NSString *> *)titles
         placeholderImage:(UIImage*)placeholderImage;

/**
初始化方法：图片带文字说明的不显示分页控件，但是会有总数和当前页的显示：2/20

@param frame 位置尺寸
@param arrayDict 是字典数组：（字典结构为：@{@"imageUrl":@"",@"title":@""}）imageUrl可以是本地的，也可以是网络的图片链接
@param placeholderImage 占位图片
@return ZJCycleView对象
*/
- (instancetype)initWithFrame:(CGRect)frame
                arrayDict:(NSArray <NSDictionary *> *)arrayDict
         placeholderImage:(UIImage*)placeholderImage;

/**
初始化方法

@param frame 位置尺寸
@param imageUrls 需要加载的图片数组，可以是本地的，也可以是网络的图片
@param placeholderImage 占位图片
@return ZJCycleView对象
*/
+ (instancetype)cycleViewWithFrame:(CGRect)frame
                     imageUrls:(NSArray <NSString *> *)imageUrls
              placeholderImage:(UIImage *)placeholderImage;

/**
初始化方法：图片带文字说明的不显示分页控件，但是会有总数和当前页的显示：2/20

@param frame 位置尺寸
@param imageUrls 需要加载的图片数组，可以是本地的，也可以是网络的图片
@param titles 每张图片对应要显示的文字数组
@param placeholderImage 占位图片
@return ZJCycleView对象
*/
+ (instancetype)cycleViewWithFrame:(CGRect)frame
                imageUrls:(NSArray <NSString *> *)imageUrls
                   titles:(NSArray <NSString *> *)titles
         placeholderImage:(UIImage*)placeholderImage;

/**
初始化方法：图片带文字说明的不显示分页控件，但是会有总数和当前页的显示：2/20

@param frame 位置尺寸
@param arrayDict 是字典数组：（字典结构为：@{@"imageUrl":@"",@"title":@""}）imageUrl可以是本地的，也可以是网络的图片链接
@param placeholderImage 占位图片
@return ZJCycleView对象
*/
+ (instancetype)cycleViewWithFrame:(CGRect)frame
                     arrayDict:(NSArray <NSDictionary *> *)arrayDict
              placeholderImage:(UIImage*)placeholderImage;

/**
当选中的ZJCyclePageContolStyle 是ZJCyclePageContolStyleImage, 图片类型的时候调用，如果不调用使用默认图片

@param currentImage 选中图片
@param pageImage 默认图片
*/
- (void)currentImage:(UIImage *)currentImage
      pageImage:(UIImage *)pageImage;

/**
当选中的ZJCyclePageContolStyle 不是ZJCyclePageContolStyleImage,如果不使用默认颜色，可以调用此方法设置

@param currentColor 选中颜色
@param pageColor 默认颜色
*/
-(void)currentColor:(UIColor *)currentColor
      pageColor:(UIColor *)pageColor;

@end
