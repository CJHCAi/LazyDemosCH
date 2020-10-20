//
//  FJBannerScrollView.m
//  ScrollviewDemo
//
//  Created by MacBook on 2017/12/28.
//  Copyright © 2017年 李Sir灬. All rights reserved.
//

#import "FJBannerScrollView.h"
#import "UIImageView+WebCache.h"
#import "MacrosHeader.h"

#define ScrollViewWidth self.scrollView.frame.size.width
#define ScrollViewHeight self.scrollView.frame.size.height

@interface FJBannerScrollView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIImageView *leftIV;
@property (nonatomic, strong) UIImageView *centerIV;
@property (nonatomic, strong) UIImageView *rightIV;

@property (nonatomic, strong) NSArray *carouselArray;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSTimer *timer;  //定时器用于滚动轮播图

@property (nonatomic, assign) NSInteger currentPage;  //当前页

@end

@implementation FJBannerScrollView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    
    return self;
}

-(void)creatUI {
    [self addSubview:self.scrollView];
    
    self.leftIV = [[UIImageView alloc] init];
    [self.scrollView addSubview:self.leftIV];
    
    self.centerIV = [[UIImageView alloc] init];
    [self.scrollView addSubview:self.centerIV];
    
    self.rightIV = [[UIImageView alloc] init];
    [self.scrollView addSubview:self.rightIV];
    
    self.scrollView.delegate = self;
}
//初始化轮播数组
-(void)setCarouseWithArray:(NSArray *)array {
    if (array.count == 0) {
        return;
    }
    self.carouselArray = array;
    self.currentPage = 0;
    self.pageControl.numberOfPages = array.count;
    self.pageControl.userInteractionEnabled = NO;
    [self updateScrollViewAndImage];
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click)];
    [self addGestureRecognizer:tap];
    [self fireTimer];
}

-(UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:245.0/255 green:98.0/255 blue:45.0/255 alpha:1.0];
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        [self addSubview:_pageControl];
    }
    
    return _pageControl;
}

- (void)setImgWidth:(CGFloat)imgWidth {
    _imgWidth = imgWidth;
}

- (void)setDefaultImg:(NSString *)defaultImg {
    _defaultImg = defaultImg;
    self.leftIV.image = [UIImage imageNamed:_defaultImg];
    self.centerIV.image = [UIImage imageNamed:_defaultImg];
    self.rightIV.image = [UIImage imageNamed:_defaultImg];
}

- (void)setImgCornerRadius:(CGFloat)imgCornerRadius {
    _imgCornerRadius = imgCornerRadius;
    if (imgCornerRadius == 0) {
        return;
    }
    self.leftIV.layer.cornerRadius = _imgCornerRadius;
    self.leftIV.layer.masksToBounds = YES;
    self.centerIV.layer.cornerRadius = _imgCornerRadius;
    self.centerIV.layer.masksToBounds = YES;
    self.rightIV.layer.cornerRadius = _imgCornerRadius;
    self.rightIV.layer.masksToBounds = YES;
}

- (void)setImgMargnPadding:(CGFloat)imgMargnPadding {
    _imgMargnPadding = imgMargnPadding;
    self.scrollView.frame = CGRectMake((fj_screenWidth - (self.imgWidth + imgMargnPadding))/2, 0, self.imgWidth + imgMargnPadding, self.frame.size.height);
    self.pageControl.frame = CGRectMake(0, ScrollViewHeight - 25, fj_screenWidth, 20);
    [self.scrollView setContentSize:CGSizeMake(ScrollViewWidth * 3, ScrollViewHeight)];
    [self.scrollView setContentOffset:CGPointMake(ScrollViewWidth, 0)];
    
    [self updateViewFrame];
}
//定时器自动轮播
-(void)animalImage {
    [UIView animateWithDuration:0.3 animations:^{
        [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.scrollView.frame) * 2, 0)];
        
        self.rightIV.frame = CGRectMake(ScrollViewWidth * 2+self.imgMargnPadding/2, 0, self.imgWidth, ScrollViewHeight);
        self.leftIV.frame = CGRectMake(self.imgMargnPadding/2, self.imgEdgePadding/2, self.imgWidth, ScrollViewHeight);
        
    } completion:^(BOOL finished) {
        if (finished) {
            
            [self updateViewFrame];
            [self updateCurrentPageWithDirector:NO];
            [self updateScrollViewAndImage];
        }
    }];
    
    
}
//滚动后更新scrollView的位置和显示的图片
-(void)updateScrollViewAndImage{
    [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.scrollView.frame), 0)];
    
    NSInteger pageCount = self.carouselArray.count;
    if (pageCount == 0) {
        return;
    }
    //
    NSInteger leftIndex = (_currentPage > 0) ? (_currentPage - 1) : (pageCount - 1);
    NSInteger rightIndex = (_currentPage < pageCount - 1) ? (_currentPage + 1) : 0;
    
    NSDictionary *leftDic = self.carouselArray[leftIndex];
    NSDictionary *centerDic = self.carouselArray[_currentPage];
    NSDictionary *rightDic = self.carouselArray[rightIndex];
    
    NSString *leftString = [leftDic objectForKey:@"image"];
    NSString *centerString = [centerDic objectForKey:@"image"];
    NSString *rightString = [rightDic objectForKey:@"image"];
    
    
    [self.leftIV sd_setImageWithURL:[NSURL URLWithString:leftString]
                   placeholderImage:[UIImage imageNamed:self.defaultImg]];
    [self.centerIV sd_setImageWithURL:[NSURL URLWithString:centerString]
                     placeholderImage:[UIImage imageNamed:self.defaultImg]];
    [self.rightIV sd_setImageWithURL:[NSURL URLWithString:rightString]
                    placeholderImage:[UIImage imageNamed:self.defaultImg]];
    
    [self.pageControl setCurrentPage:_currentPage];
    
    //    NSLog(@"%ld", _currentPage);
    
}

-(void)click {
    if ([_bannerScrolldelegate respondsToSelector:@selector(selectedIndex:)] ) {
        [_bannerScrolldelegate selectedIndex:_currentPage];
    }
}

-(void)updateCurrentPageWithDirector:(BOOL) isRight{
    NSInteger pageCount = self.carouselArray.count;
    if (pageCount == 0) {
        return;
    }
    if (isRight) {
        self.currentPage = self.currentPage > 0 ? (self.currentPage - 1) : (pageCount - 1);
    }else{
        self.currentPage = (self.currentPage + 1) % pageCount;
    }
}

#pragma mark UIScrollerViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:5.0]];
    if (self.scrollView.contentOffset.x == 0)
    {
        [self updateCurrentPageWithDirector:YES];
    }
    else if (self.scrollView.contentOffset.x > CGRectGetWidth(scrollView.frame))
    {
        [self updateCurrentPageWithDirector:NO];
        
    }else{
        return;
    }
    [self updateViewFrame];
    [self updateScrollViewAndImage];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.scrollView.contentOffset.x > CGRectGetWidth(scrollView.frame)) {
        
        self.rightIV.frame = CGRectMake(ScrollViewWidth * 2+self.imgMargnPadding/2, self.imgEdgePadding/2-(self.scrollView.contentOffset.x-ScrollViewWidth)*self.imgEdgePadding/2/ScrollViewWidth, self.imgWidth, ScrollViewHeight-(self.imgEdgePadding-(self.scrollView.contentOffset.x-ScrollViewWidth)*self.imgEdgePadding/ScrollViewWidth));
        
        self.centerIV.frame = CGRectMake(ScrollViewWidth+self.imgMargnPadding/2, (self.scrollView.contentOffset.x-ScrollViewWidth)*self.imgEdgePadding/2/ScrollViewWidth, self.imgWidth, ScrollViewHeight-(self.scrollView.contentOffset.x-ScrollViewWidth)*self.imgEdgePadding/ScrollViewWidth);
        
    }else if(self.scrollView.contentOffset.x < CGRectGetWidth(scrollView.frame)){
        
        self.leftIV.frame = CGRectMake(self.imgMargnPadding/2, self.imgEdgePadding/2+(self.scrollView.contentOffset.x-ScrollViewWidth)*self.imgEdgePadding/2/ScrollViewWidth, self.imgWidth, ScrollViewHeight-(self.imgEdgePadding+ (self.scrollView.contentOffset.x-ScrollViewWidth)*self.imgEdgePadding/ScrollViewWidth));
        
        self.centerIV.frame = CGRectMake(ScrollViewWidth+self.imgMargnPadding/2, -(self.scrollView.contentOffset.x-ScrollViewWidth)*self.imgEdgePadding/2/ScrollViewWidth, self.imgWidth, ScrollViewHeight+(self.scrollView.contentOffset.x-ScrollViewWidth)*self.imgEdgePadding/ScrollViewWidth);
        
    }
    
}
//取消定时器
-(void)invalidateTimer
{
    if (_timer && [_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
}

-(void)fireTimer {
    [self invalidateTimer];
    //如果有图片才开启定时器
    if (self.carouselArray.count > 0) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(animalImage) userInfo:nil repeats:YES];
    }
    
}

-(UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.clipsToBounds = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor clearColor];
    }
    return _scrollView;
}

-(void)updateViewFrame {
    
    self.leftIV.frame = CGRectMake(self.imgMargnPadding/2, self.imgEdgePadding/2, self.imgWidth, ScrollViewHeight-self.imgEdgePadding);
    self.centerIV.frame = CGRectMake(ScrollViewWidth+self.imgMargnPadding/2, 0, self.imgWidth, ScrollViewHeight);
    self.rightIV.frame = CGRectMake(ScrollViewWidth * 2+self.imgMargnPadding/2, self.imgEdgePadding/2, self.imgWidth, ScrollViewHeight-self.imgEdgePadding);
    
}


@end

