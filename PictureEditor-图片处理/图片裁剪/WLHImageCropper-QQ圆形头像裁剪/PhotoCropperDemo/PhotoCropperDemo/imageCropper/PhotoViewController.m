//
//  PhotoViewController.m
//  incup
//
//  Created by wanglh on 15/4/27.
//  Copyright (c) 2015年 Kule Yang. All rights reserved.
//
//#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:r/256.0 green:g/256.0 blue:b/256.0 alpha:a]

#import "PhotoViewController.h"
#import "PhotoMaskView.h"
#import "UIImage+Crop.h"
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:r/256.0 green:g/256.0 blue:b/256.0 alpha:a]

@interface PhotoViewController ()<UIScrollViewDelegate,PhotoMaskViewDelegate>
@property (nonatomic,strong) PhotoMaskView *maskView;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIButton *btn;
//@property (nonatomic,strong) UIImageView *cropImageView;
@end

@implementation PhotoViewController{
    CGRect            _rect;
    UIImageView      *_imageView;
    UIView           *_cropView;
    UIEdgeInsets      _imageInset;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor blackColor];
    self.oldImage = [UIImage fitScreenWithImage:self.oldImage];
    self.backImage = @"icn_back.png";
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _imageView = [[UIImageView alloc] initWithImage:self.oldImage];
    
    _imageView.center = self.view.center;
    _scrollView.delegate = self;
    self.scrollView.contentSize = self.oldImage.size;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = YES;
    [self.scrollView addSubview:_imageView];
      [self.view addSubview:self.scrollView];
    // maskView
    CGFloat height = 0;
    CGFloat width = 0;
    self.cropHeight?height = self.cropHeight:0;
    if ( self.mode == PhotoMaskViewModeCircle) {
        if (self.cropWidth) {
            height = self.cropWidth;
            self.cropHeight = self.cropWidth;
            width = height;
        }else{
            width = self.cropHeight;
            self.cropWidth = self.cropHeight;
            height = width;
        }
    }else{
        height = self.cropHeight;
        width = self.cropWidth;
    }
    _maskView = [[PhotoMaskView alloc] initWithFrame:self.view.bounds width:width height:height];
    _maskView.mode = self.mode;
    _maskView.userInteractionEnabled = NO;
  
    _isDark?_maskView.isDark = YES:0;
    _lineColor?_maskView.lineColor = _lineColor:0;
    [self.view addSubview:self.maskView];
    self.maskView.delegate = self;
    [self bottomView];
    [self customNav];
}
-(void)customNav
{
//    icn_back.png
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.7f;
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 12, 50, 40);
    [backBtn setImage:[UIImage imageNamed:self.backImage] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:backBtn];
    [self.view addSubview:bgView];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    titleLabel.font = [UIFont boldSystemFontOfSize:21];
    titleLabel.text = _cropTitle?_cropTitle:@"移动和缩放";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleLabel];
}

-(void)bottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-45, SCREEN_WIDTH, 45)];
//    NSArray *arr = @[@"取消",@"确定"];
//    for (int i=0; i<2; i++) {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    view.backgroundColor = [UIColor whiteColor];
    view.alpha = 0.8f;
    [bottomView addSubview:view];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(1*(SCREEN_WIDTH - 80), 7, 70, 31)];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [bottomView addSubview:btn];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = _btnBackgroundColor?_btnBackgroundColor:RGBACOLOR(79,181,180,1);
    btn.layer.cornerRadius = 4;
    [btn addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomView];
    
}
-(void)backBtn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageCropperDidCancel:)]) {
        [self.delegate imageCropperDidCancel:self];
    }
}
- (void)buttonClicked
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageCropper:didFinished:)]) {
        [self.delegate imageCropper:self didFinished:[self cropImage]];
    }
}

-(void)layoutScrollViewWithRect:(CGRect)rect
{
    _rect = rect;
    CGFloat top = (self.oldImage.size.height-rect.size.height)/2;
    CGFloat left = (self.oldImage.size.width-rect.size.width)/2;
    CGFloat bottom = self.view.bounds.size.height-top-rect.size.height;
    CGFloat right = self.view.bounds.size.width-rect.size.width-left;
    self.scrollView.contentInset = UIEdgeInsetsMake(top, left, bottom, right);
    CGFloat maskCircleWidth = rect.size.width;
    
    CGSize imageSize = self.oldImage.size;
    //setp 2: setup contentSize:
    CGFloat minimunZoomScale = imageSize.width < imageSize.height ? maskCircleWidth / imageSize.width : maskCircleWidth / imageSize.height;
    CGFloat maximumZoomScale = 1.5;
    self.scrollView.minimumZoomScale = minimunZoomScale;
    self.scrollView.maximumZoomScale = maximumZoomScale;
    self.scrollView.zoomScale = self.scrollView.zoomScale < minimunZoomScale ? minimunZoomScale : self.scrollView.zoomScale;
    _imageInset = self.scrollView.contentInset;
    
}
- (UIImage *)cropImage {
    CGFloat zoomScale = _scrollView.zoomScale;
    
    CGFloat offsetX = _scrollView.contentOffset.x;
    CGFloat offsetY = _scrollView.contentOffset.y;
    CGFloat aX = offsetX>=0 ? offsetX+_imageInset.left : (_imageInset.left - ABS(offsetX));
    CGFloat aY = offsetY>=0 ? offsetY+_imageInset.top : (_imageInset.top - ABS(offsetY));
    
    aX = aX / zoomScale;
    aY = aY / zoomScale;
    
    CGFloat aWidth =  MAX(self.cropWidth / zoomScale, self.cropWidth);
    CGFloat aHeight = MAX(self.cropHeight / zoomScale, self.cropHeight);
    if (zoomScale>1) {
        aWidth = self.cropWidth/zoomScale;
        aHeight = self.cropHeight/zoomScale;
    }
    
    UIImage *image = [self.oldImage cropImageWithX:aX y:aY width:aWidth height:aHeight];
    image = [UIImage imageWithImageSimple:image scaledToSize:CGSizeMake(self.cropWidth, self.cropHeight)];
    return image;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
}
@end
