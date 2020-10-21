//
//  YLPBCollectionViewCell.m
//  SportChina
//
//  Created by 杨磊 on 2018/3/20.
//  Copyright © 2018年 Beijing Sino Dance Culture Media Co.,Ltd. All rights reserved.
//

#import "YLPBCollectionViewCell.h"
#import "SDWebImagePrefetcher.h"
#import "UIImageView+WebCache.h"
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
@interface YLPBCollectionViewCell()<UIScrollViewDelegate>
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, strong) UIView *activitView;
@end
@implementation YLPBCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame])
    {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.mainScrollView = [[UIScrollView alloc] init];
    self.mainScrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.mainScrollView.minimumZoomScale = 1.f;
    self.mainScrollView.maximumZoomScale = 4.0;
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.delegate = self;
    [self.contentView addSubview:self.mainScrollView];
    
    self.photoImg = [[UIImageView alloc] init];
    self.photoImg.image = [UIImage imageNamed:@"defImage"];
    self.photoImg.frame = CGRectMake(0, (SCREEN_HEIGHT - SCREEN_WIDTH)/2.f, SCREEN_WIDTH, SCREEN_WIDTH);
    [self.mainScrollView addSubview:self.photoImg];

    [self addGestureRecognizer:self.doubleTap];
    [self addGestureRecognizer:self.singleTap];
}

- (void)setModel:(NSString *)model
{
    _model = model;
    NSString *imgeUrl = [NSString stringWithFormat:@"%@",model];
    NSString *s = [imgeUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *netUrl = [NSURL URLWithString:s];
    UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:s];
    UIImageView *textimage = [[UIImageView alloc] initWithImage:cachedImage];
    self.photoImg.image = [UIImage imageNamed:@"defImage"];;
    self.photoImg.frame = CGRectMake(0, (SCREEN_HEIGHT - SCREEN_WIDTH)/2.f, SCREEN_WIDTH, SCREEN_WIDTH);
    if (textimage.frame.size.width == 0)
    {
        [self showActivity];
    }else
    {
        [self hideActivity];
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        SDWebImagePrefetcher *magePre = [SDWebImagePrefetcher sharedImagePrefetcher];
        [magePre prefetchURLs:@[netUrl] progress:^(NSUInteger noOfFinishedUrls, NSUInteger noOfTotalUrls) {
            UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:s];
            UIImageView *textimage = [[UIImageView alloc] initWithImage:cachedImage];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.photoImg.frame = [self setImage:textimage];
                self.photoImg.image = cachedImage;
                //设置scroll的contentsize的frame
                self.mainScrollView.contentSize = self.photoImg.frame.size;
                [self hideActivity];
            });
        } completed:^(NSUInteger noOfFinishedUrls, NSUInteger noOfSkippedUrls) {
        }];
    });
}

//根据不同的比例设置尺寸
-(CGRect) setImage:(UIImageView *)imageView
{
    
    CGFloat imageX = imageView.frame.size.width;
    
    CGFloat imageY = imageView.frame.size.height;
    
    CGRect imgfram;
    
    CGFloat CGscale;
    
    BOOL flx =  (SCREEN_WIDTH / SCREEN_HEIGHT) > (imageX / imageY);
    
    if(flx)
    {
        CGscale = SCREEN_HEIGHT / imageY;
        
        imageX = imageX * CGscale;
        
        imgfram = CGRectMake((SCREEN_WIDTH - imageX) / 2, 0, imageX, SCREEN_HEIGHT);
        
        return imgfram;
    }
    else
    {
        CGscale = SCREEN_WIDTH / imageX;
        
        imageY = imageY * CGscale;
        
        imgfram = CGRectMake(0, (SCREEN_HEIGHT - imageY) / 2, SCREEN_WIDTH, imageY);
        
        return imgfram;
    }
    
}

//这个方法的返回值决定了要缩放的内容(只能是UISCrollView的子控件)
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.photoImg;
}
//控制缩放是在中心
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    self.photoImg.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                       
                                       scrollView.contentSize.height * 0.5 + offsetY);
}
/** 双击 */

- (UITapGestureRecognizer *)doubleTap
{
    if (!_doubleTap)
    {
        _doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doDoubleTap:)];
        _doubleTap.numberOfTapsRequired = 2;
        _doubleTap.numberOfTouchesRequired  =1;
    }
    return _doubleTap;
}

- (void)doDoubleTap:(UITapGestureRecognizer *)recognizer
{
    CGPoint touchPoint = [recognizer locationInView:self];
    if (self.mainScrollView.zoomScale <= 1.0)
    {
        CGFloat scaleX = touchPoint.x + self.mainScrollView.contentOffset.x;//需要放大的图片的X点
        CGFloat sacleY = touchPoint.y + self.mainScrollView.contentOffset.y;//需要放大的图片的Y点
        [self.mainScrollView zoomToRect:CGRectMake(scaleX, sacleY, 10, 10) animated:YES];
    }
    else
    {
        [self.mainScrollView setZoomScale:1.0 animated:YES]; //还原
    }
}
- (UITapGestureRecognizer *)singleTap
{
    if (!_singleTap)
    {
        _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doSingleTap)];
        _singleTap.numberOfTapsRequired = 1;
        _singleTap.numberOfTouchesRequired = 1;
        [_singleTap requireGestureRecognizerToFail:self.doubleTap];//系统会先判定是不是双击，如果不是，才会调单击的事件
        
    }
    return _singleTap;
}
- (void)doSingleTap
{
    if (self.click) {
        self.click();
    }
}

- (UIActivityIndicatorView *)indicator
{
    if (!_indicator) {
        _indicator = [[UIActivityIndicatorView alloc] init];
        _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        _indicator.center = CGPointMake(65, 40);
        [self.activitView addSubview:_indicator];
    }
    return _indicator;
}
- (UIView *)activitView
{
    if (!_activitView) {
        _activitView = [UIView new];
        _activitView.frame = CGRectMake((SCREEN_WIDTH - 100)/2, (SCREEN_HEIGHT - 80)/2, 130, 100);
        _activitView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        _activitView.layer.cornerRadius = 10;
        _activitView.clipsToBounds = YES;
        
        UILabel *label = [UILabel new];
        label.frame = CGRectMake(0, 60, 130, 20);
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:15.f];
        label.text = @"图片加载中...";
        label.textAlignment = NSTextAlignmentCenter;
        [_activitView addSubview:label];
        [self addSubview:_activitView];
    }
    return _activitView;
}
- (void)showActivity
{
    [self.indicator startAnimating];
    self.activitView.hidden = NO;
}

- (void)hideActivity
{
    self.activitView.hidden = YES;
    [self.indicator stopAnimating];
}
@end
