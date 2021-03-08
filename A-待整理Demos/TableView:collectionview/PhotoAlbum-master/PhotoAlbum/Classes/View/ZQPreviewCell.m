//
//  ZQPreviewCell.m
//  PhotoAlbum
//
//  Created by ZhouQian on 16/6/2.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import "ZQPreviewCell.h"
#import "ZQPhotoModel.h"
#import "ZQPhotoFetcher.h"
#import "ZQPublic.h"


#define kPhotoCellMargin 2

@interface ZQPreviewCell () <UIScrollViewDelegate>



@end
@implementation ZQPreviewCell

- (instancetype)init {
    return [self initWithFrame:CGRectMake(0, 0, kTPScreenWidth, kTPScreenHeight)];
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.scrollView.bouncesZoom = YES;
        self.scrollView.maximumZoomScale = 2.5;
        self.scrollView.minimumZoomScale = 1.0;
        self.scrollView.multipleTouchEnabled = YES;
        self.scrollView.delegate = self;
        self.scrollView.scrollsToTop = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.scrollView.delaysContentTouches = NO;
        self.scrollView.canCancelContentTouches = YES;
        self.scrollView.alwaysBounceVertical = NO;
        self.scrollView.contentSize = CGSizeMake(frame.size.width, frame.size.height);
        [self addSubview:self.scrollView];
        
        self.ivPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(kPhotoCellMargin, 0, frame.size.width-kPhotoCellMargin*2, frame.size.height)];
        self.ivPhoto.backgroundColor = [UIColor blackColor];
        self.ivPhoto.contentMode = UIViewContentModeScaleAspectFit;
        self.ivPhoto.layer.masksToBounds = YES;
        [self.scrollView addSubview:self.ivPhoto];
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [self addGestureRecognizer:tap1];
        
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        tap2.numberOfTapsRequired = 2;
        [tap1 requireGestureRecognizerToFail:tap2];
        [self addGestureRecognizer:tap2];
        
    }
    return self;
}


- (void)display:(BOOL)bSingleSelect cache:(NSCache *)cache indexPath:(NSIndexPath *)indexPath {
    ______WS();
    UIImage *image = [cache objectForKey:indexPath];
    if (image) {
        self.ivPhoto.image = image;
    }
    else {
        self.mPhoto.requestID = [ZQPhotoFetcher getPhotoFastWithAssets:self.mPhoto.asset photoWidth:kTPScreenWidth completionHandler:^(UIImage *image, NSDictionary *info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (image) {
                    wSelf.ivPhoto.image = image;
                    [cache setObject:image forKey:indexPath];
                    [wSelf autouLayoutImageView:bSingleSelect];
                }
                
            });
        }];
    }
    
}

- (void)singleTap:(UITapGestureRecognizer *)tap {
    if (self.singleTapBlock) {
        self.singleTapBlock();
    }
}
- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (self.scrollView.zoomScale > 1.0) {
        [self.scrollView setZoomScale:1.0 animated:YES];
    }
    else {
        CGPoint touchPoint = [tap locationInView:self.ivPhoto];
        CGFloat newZoomScale = self.scrollView.maximumZoomScale;
        CGFloat xsize = self.frame.size.width / newZoomScale;
        CGFloat ysize = self.frame.size.height / newZoomScale;
        [self.scrollView zoomToRect:CGRectMake(touchPoint.x - xsize / 2.0, touchPoint.y - ysize / 2.0, xsize, ysize) animated:YES];
    }
}
#pragma mark - 调整图片大小
- (void)autouLayoutImageView:(BOOL)bSingleSelect {
    CGFloat viewWidth = CGRectGetWidth(self.frame);
    CGFloat viewHeight = CGRectGetHeight(self.frame);
    
    CGRect rect = CGRectZero;
    rect.origin = CGPointZero;
    rect.size.width = viewWidth;
    
    UIImage *image = self.ivPhoto.image;
    if (image.size.height / image.size.width > viewHeight / viewWidth) {//竖长图，算高度
        rect.size.height = floor(image.size.height / (image.size.width / viewWidth));
    }
    else {//横图
        CGFloat height = image.size.height / image.size.width * viewWidth;
        if (height < 1 || isnan(height)) {
            height = viewHeight;
        }
        height = floor(height);
        rect.size.height = height;
        rect.origin.y = (viewHeight - height) / 2.0;
    }
    if (rect.size.height > viewHeight && rect.size.height - viewHeight <= 1) {
        rect.size.height = viewHeight;
    }
    
    self.scrollView.contentSize = CGSizeMake(viewWidth, MAX(rect.size.height, viewHeight));
    [self.scrollView scrollRectToVisible:self.bounds animated:NO];
    self.scrollView.alwaysBounceVertical = rect.size.height <= viewHeight ? NO : YES;
    self.ivPhoto.frame = rect;
    
    if (bSingleSelect) {
        CGFloat height = self.scrollView.contentSize.height;
        CGFloat cropHeight = [UIScreen mainScreen].bounds.size.width;
        self.scrollView.contentSize = CGSizeMake(viewWidth, (rect.size.height-cropHeight)+height);
        [self.scrollView scrollRectToVisible:CGRectMake(0, (rect.size.height-cropHeight)/2, self.bounds.size.width, self.bounds.size.height) animated:NO];
        self.scrollView.alwaysBounceVertical = YES;
        self.ivPhoto.frame = CGRectMake(rect.origin.x, rect.origin.y+(rect.size.height-cropHeight)/2, rect.size.width, rect.size.height);
    }
    
}

#pragma mark - UIScrollView代理
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.ivPhoto;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat width = CGRectGetWidth(scrollView.frame);
    CGFloat height = CGRectGetHeight(scrollView.frame);
    
    CGFloat offsetX = (width > scrollView.contentSize.width) ? (width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (height > scrollView.contentSize.height) ? (height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.ivPhoto.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}

#pragma mark - Crop Image
- (UIImage *)crop:(CGRect)rect {
    // F = frame
    // i = image
    // iv = imageview
    // sv = self.view
    // of = offset
    
    //Frame Image in imageView coordinates
    CGRect Fi_iv = [self frameForImage:self.ivPhoto.image inImageViewAspectFit:self.ivPhoto];
    
    //Frame ImageView in self.view coordinates
    CGRect Fiv_sv = self.ivPhoto.frame;
    
    //Frame Image in self.view coordinates
    CGRect Fi_sv = CGRectMake(Fi_iv.origin.x + Fiv_sv.origin.x
                              ,Fi_iv.origin.y + Fiv_sv.origin.y,
                              Fi_iv.size.width, Fi_iv.size.height);
    //ScrollView offset
    CGPoint offset = self.scrollView.contentOffset;
    
    //Frame Image in offset coordinates
    CGRect Fi_of = CGRectMake(Fi_sv.origin.x - offset.x,
                              Fi_sv.origin.y - offset.y,
                              Fi_sv.size.width,
                              Fi_sv.size.height);
    
    CGFloat scale = self.ivPhoto.image.size.width/Fi_of.size.width;
    
    //the crop frame in image offset coordinates
    CGRect Fcrop_iof = CGRectMake((rect.origin.x - Fi_of.origin.x)*scale,
                                  (rect.origin.y - Fi_of.origin.y)*scale,
                                  rect.size.width*scale,
                                  rect.size.height*scale);
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.ivPhoto.image.CGImage, Fcrop_iof);
    return [UIImage imageWithCGImage:imageRef];
}

-(CGRect)frameForImage:(UIImage*)image inImageViewAspectFit:(UIImageView*)imageView
{
    float imageRatio = image.size.width / image.size.height;
    float viewRatio = imageView.frame.size.width / imageView.frame.size.height;
    
    if(imageRatio < viewRatio)//竖长图
    {
        float scale = imageView.frame.size.height / image.size.height;
        float width = scale * image.size.width;
        float topLeftX = (imageView.frame.size.width - width) * 0.5;
        
        return CGRectMake(topLeftX, 0, width, imageView.frame.size.height);
    }
    else//横图
    {
        float scale = imageView.frame.size.width / image.size.width;
        float height = scale * image.size.height;
        float topLeftY = (imageView.frame.size.height - height) * 0.5;
        
        return CGRectMake(0, topLeftY, imageView.frame.size.width, height);
    }
}

- (void)prepareForReuse {
    [ZQPhotoFetcher cancelRequest:self.mPhoto.requestID];
    self.mPhoto = nil;
}
@end
