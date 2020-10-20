//
//  FJBannerScrollView.h
//  ScrollviewDemo
//
//  Created by MacBook on 2017/12/28.
//  Copyright © 2017年 李Sir灬. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BannerScrollViewDelegate <NSObject>

-(void)selectedIndex:(NSInteger)index;

@end

@interface FJBannerScrollView : UIView

@property (nonatomic, assign) id<BannerScrollViewDelegate> bannerScrolldelegate;

@property (nonatomic, strong) UIScrollView *scrollView;
//默认图
@property (nonatomic, copy) NSString *defaultImg;
//两个图片间距
@property (nonatomic, assign) CGFloat imgMargnPadding;
//边距
@property (nonatomic, assign) CGFloat imgEdgePadding;
//图片宽度
@property (nonatomic, assign) CGFloat imgWidth;
//圆角（0的时候没有圆角）
@property (nonatomic, assign) CGFloat imgCornerRadius;



-(void)setCarouseWithArray:(NSArray *)array;

@end
