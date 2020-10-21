//
//  ZJPhotoView.m
//  ZJPhotoBrowserDemo
//
//  Created by 陈志健 on 2017/4/10.
//  Copyright © 2017年 chenzhijian. All rights reserved.
//

#import "ZJPhotoView.h"
#import "UIImageView+WebCache.h"
#import "ZJIndicatorView.h"
@implementation ZJPhotoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.userInteractionEnabled = YES;
        self.delegate = self;
        [self addSubview:_imageView];
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.maximumZoomScale = 3.0;
        self.minimumZoomScale = 1.0;

        //单击手势
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
        [self addGestureRecognizer:singleTap];
        
        //双击手势
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        [singleTap requireGestureRecognizerToFail:doubleTap];
        
        //长按手势
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [self addGestureRecognizer:longPress];

    }
    return self;
}


- (void)setZjPhoto:(ZJPhoto *)zjPhoto {
    
    if (_zjPhoto == zjPhoto) {
        
        if (self.bigImageHasLoad == NO) {
            
            [self showBigImage];
        }
        return;
    }
    _zjPhoto = zjPhoto;

    self.maximumZoomScale = _zjPhoto.maxZoomScale;
    self.minimumZoomScale = _zjPhoto.minZoomScale;
    [self showBigImage];
    
}
//显示大图
- (void)showBigImage{

    _imageView.image = _zjPhoto.srcImageView.image;
    
    _imageView.frame = [_zjPhoto.srcImageView convertRect:_zjPhoto.srcImageView.bounds toView:nil];

    CGRect imageRect = [self adjustFrameWithImage:_zjPhoto.srcImageView.image];
    
    CGFloat duration = _zjPhoto.isTapImage ? .3 : 0;

    
    [UIView animateWithDuration:duration animations:^{
        
        _imageView.frame = imageRect;
        
    } completion:^(BOOL finished) {
        
        //加载大图
        if (_zjPhoto.url) {
            
            [self loadBigImageWithUrl];
        }
    }];
    
}
//加载大图
- (void)loadBigImageWithUrl {

    //进度条视图
    ZJIndicatorView *indicatorView = [ZJIndicatorView indicatorShowInView:self];
    //加载大图
    [_imageView sd_setImageWithURL:_zjPhoto.url placeholderImage:_zjPhoto.srcImageView.image options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            indicatorView.progress = (CGFloat)receivedSize / expectedSize;
        });
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        BOOL success = YES;
        if (error) {
       
            success = NO;
        }
        self.bigImageHasLoad = success;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [indicatorView hideIndicatorViewWithSucceed:success];
        });
    }];

}



//单击
- (void)singleTapAction:(UITapGestureRecognizer *)tap {
    
    //先还原
    [self setZoomScale:1.0 animated:YES];

    //代理处理
    if ([self.photoDelegate respondsToSelector:@selector(zjPhotoView:receiveTapWithZJPhotoTapType:)]) {
        [self.photoDelegate zjPhotoView:self receiveTapWithZJPhotoTapType:ZJPhotoTapTypeOne];
    }
}

//双击
- (void)doubleTapAction:(UITapGestureRecognizer *)tap {

    CGPoint touchPoint = [tap locationInView:self];
    if (self.zoomScale <= 1.0) {
        
        CGFloat scaleWidth = self.frame.size.width / self.maximumZoomScale;
        CGFloat scaleHeight = self.frame.size.height / self.maximumZoomScale;

        [self zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, scaleWidth, scaleHeight) animated:YES];

    } else {
        //还原
        [self setZoomScale:1.0 animated:YES];
    }
}

//长按
- (void)longPress:(UILongPressGestureRecognizer *)longPress{

    //代理处理
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if ([self.photoDelegate respondsToSelector:@selector(zjPhotoView:receiveTapWithZJPhotoTapType:)]) {
            [self.photoDelegate zjPhotoView:self receiveTapWithZJPhotoTapType:ZJPhotoTapTypeLong];
        }

    }

}

#pragma mark 调整frame
- (CGRect)adjustFrameWithImage:(UIImage *)image {
    
    
    if (image == nil) {
        
        return CGRectMake(0, 0, kZJPhotoScreenWidth, kZJPhotoScreenHeight);
    }
    if (_imageView.image == nil) {
    
        return CGRectZero;
    }
    CGFloat height = kZJPhotoScreenWidth / image.size.width * image.size.height;
    CGFloat y = (kZJPhotoScreenHeight - height)/2;
    //判断图片高度是否大于屏幕.
    if (height >= kZJPhotoScreenHeight) {
        y = 0;
    }
    self.contentSize = CGSizeMake(kZJPhotoScreenWidth, height);
    CGRect imageFrame = CGRectMake(0, y, kZJPhotoScreenWidth, height);
    
    return imageFrame;
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}
//以中心点缩放
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    _imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                    scrollView.contentSize.height * 0.5 + offsetY);
}

@end
