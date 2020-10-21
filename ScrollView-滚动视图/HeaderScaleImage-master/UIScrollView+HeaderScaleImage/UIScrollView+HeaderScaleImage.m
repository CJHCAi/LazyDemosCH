//
//  UIScrollView+HeaderScaleImage.m
//  GNHeaderScaleImageDemo
//
//  Created by gn on 16/7/29.
//  Copyright © 2016年 gn. All rights reserved.
//

#import "UIScrollView+HeaderScaleImage.h"

#import <objc/runtime.h>

#define GNKeyPath(objc,keyPath) @(((void)objc.keyPath,#keyPath))


static char * const headerImageViewKey = "headerImageViewKey";
static char * const headerImageViewHeight = "headerImageViewHeight";

// 默认图片高度
static CGFloat const oriImageH = 200;


@implementation UIScrollView (HeaderScaleImage)

#pragma mark public Method

// 设置头部imageView的图片
- (void)setGn_headerScaleImage:(UIImage *)gn_headerScaleImage
{
    self.gn_headerImageView.image = gn_headerScaleImage;
    
    // 初始化头部视图
    [self setupHeaderImageViewFrame];
    
}
// 属性：gn_headerImage
- (UIImage *)gn_headerScaleImage
{
    return self.gn_headerImageView.image;
}

// 属性： gn_headerImageViewHeight
- (void)setGn_headerScaleImageHeight:(CGFloat)gn_headerScaleImageHeight
{
    objc_setAssociatedObject(self, headerImageViewHeight, @(gn_headerScaleImageHeight),OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    // 设置头部视图的位置
    [self setupHeaderImageViewFrame];
    
}
- (CGFloat)gn_headerScaleImageHeight
{
    CGFloat headerImageHeight = [objc_getAssociatedObject(self, headerImageViewHeight) floatValue];
    return headerImageHeight == 0?oriImageH:headerImageHeight;
}

#pragma mark private Methods

// 设置头部视图的位置
- (void)setupHeaderImageViewFrame
{
    // 进行一下记录
    self.gn_headerImageView.gn_originalHeight = self.gn_headerScaleImageHeight;
    self.gn_headerImageView.frame = CGRectMake(0 , 0, self.bounds.size.width , self.gn_headerScaleImageHeight);
}
#pragma mark - getter & setter
// 懒加载头部imageView
- (GNImageView *)gn_headerImageView
{
    GNImageView *imageView = objc_getAssociatedObject(self, headerImageViewKey);
    if (imageView == nil) {
        
        imageView = [[GNImageView alloc] init];
        
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [self insertSubview:imageView atIndex:0];
        
        // 保存imageView
        objc_setAssociatedObject(self, headerImageViewKey, imageView,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return imageView;
}

@end

@interface GNImageView ()

@property (nonatomic,weak) UIScrollView *scrollView;

@end

@implementation GNImageView


- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    
    // 如果不是UIScrollView，不做任何事情
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) return;
    
    // 旧的父控件移除监听
    [self removeObservers];
    
    if (newSuperview) { // 新的父控件
        // 记录UIScrollView
        _scrollView = (UIScrollView *)newSuperview;
        // 添加监听
        [self addObservers];
    }
}
#pragma mark - KVO监听
- (void)addObservers
{
    [self.scrollView addObserver:self forKeyPath:GNKeyPath(self.scrollView, contentOffset) options:NSKeyValueObservingOptionNew context:nil];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    // 获取当前偏移量
    CGFloat offsetY = self.scrollView.contentOffset.y;
    if (offsetY < 0) {
        self.frame = CGRectMake(offsetY, offsetY, self.scrollView.bounds.size.width - offsetY * 2, self.gn_originalHeight - offsetY);
    } else {
        self.frame = CGRectMake(0, 0, self.scrollView.bounds.size.width, self.gn_originalHeight);
    }
}
- (void)removeObservers
{
    [self.superview removeObserver:self forKeyPath:GNKeyPath(self.scrollView, contentOffset)];
}

@end
